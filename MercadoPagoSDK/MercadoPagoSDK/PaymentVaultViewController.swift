//
//  PaymentVaultViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentVaultViewController: MercadoPagoUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var merchantBaseUrl : String!
    var merchantAccessToken : String!
    var publicKey : String!
    var amount : Double!
    var excludedPaymentTypes : Set<PaymentTypeId>!
    var excludedPaymentMethods : [String]!
    var defaultPaymentMethodId : String?
    var currencyId : String!
    var purchaseTitle : String!
    var callback : ((paymentMethod: PaymentMethod, cardToken:CardToken?, issuer: Issuer?, installments: Int) -> Void)!
    var paymentMethodsSearch : [PaymentMethodSearchItem]!
    var paymentMethodSearchParent : PaymentMethodSearchItem?
    var defaultInstallments : Int?
    var installments : Int?
    
    var bundle = MercadoPago.getBundle()
    
    var paymentSearchCell : PaymentSearchCell!
    
    private var tintColor = true

    
    @IBOutlet weak var paymentsTable: UITableView!
    
    internal init(amount: Double, currencyId : String, purchaseTitle : String, paymentMethodSearch : [PaymentMethodSearchItem], paymentMethodSearchParent : PaymentMethodSearchItem, title: String!, callback: (paymentMethod: PaymentMethod, cardToken: CardToken?, issuer: Issuer?, installments: Int) -> Void) {
        super.init(nibName: "PaymentVaultViewController", bundle: bundle)
        self.merchantBaseUrl = MercadoPagoContext.baseURL() //distinta de null y vacia
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()//Distinta de null y vacio
        //Installment > 0
        
        //Vaidar que no excluyo todos los payment method
        
        self.publicKey = MercadoPagoContext.publicKey()
        self.title = title
        self.tintColor = false
        self.amount = amount // mayor o igual a 0
        self.purchaseTitle = purchaseTitle // que sea distinto de null y vacio
        self.currencyId = currencyId // arg, brasil, chile, colombia, mexico, venezuela, eeuu
        self.paymentMethodSearchParent = paymentMethodSearchParent
        self.paymentMethodsSearch = paymentMethodSearch
        self.callback = {(paymentMethod: PaymentMethod, cardToken: CardToken?, issuer: Issuer?, installments: Int) -> Void in
            callback(paymentMethod: paymentMethod, cardToken: cardToken, issuer: issuer, installments: installments)
        }
    }
    
    init(amount: Double, currencyId: String, purchaseTitle : String, excludedPaymentTypes: Set<PaymentTypeId>?, excludedPaymentMethods : [String]?, defaultPaymentMethodId : String?, installments : Int, defaultInstallments : Int, callback: (paymentMethod: PaymentMethod, cardToken: CardToken?, issuer: Issuer?, installments: Int) -> Void) {
        super.init(nibName: "PaymentVaultViewController", bundle: bundle)
        self.merchantBaseUrl = MercadoPagoContext.baseURL()
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()
        self.publicKey = MercadoPagoContext.publicKey()
        self.amount = amount
        self.excludedPaymentTypes = excludedPaymentTypes
        self.excludedPaymentMethods = excludedPaymentMethods
        self.purchaseTitle = purchaseTitle
        self.currencyId = currencyId
        self.defaultPaymentMethodId = defaultPaymentMethodId
        self.callback = {(paymentMethod: PaymentMethod, cardToken: CardToken?, issuer: Issuer?, installments: Int) -> Void in
            callback(paymentMethod: paymentMethod, cardToken: cardToken, issuer: issuer, installments: installments)
        }
        self.installments = installments
        self.defaultInstallments = defaultInstallments
    }
    
    required  public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.title == nil || self.title!.isEmpty {
            self.title = "¿Cómo quieres pagar?".localized
        }
        
        //Configure navigation item button
        self.navigationItem.rightBarButtonItem!.target = self
        self.navigationItem.rightBarButtonItem!.action = Selector("togglePreferenceDescription")
        
        self.paymentsTable.tableHeaderView = UIView(frame: CGRectMake(0.0, 0.0, self.paymentsTable.bounds.size.width, 0.01))
        
        self.registerAllCells()
        self.loadPaymentMethodGroups()

    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return self.displayPreferenceDescription ? 1 : 0
            case 1:
                return self.paymentMethodsSearch.count
            default :
                return 1
        }
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 10 : 0
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return displayPreferenceDescription ? 120 : 0
            case 1:
                let currentPaymentMethod = self.paymentMethodsSearch[indexPath.row]
                if currentPaymentMethod.isPaymentMethod() && !currentPaymentMethod.isBitcoin() {
                    return 80
                }
                return 52
            case 2:
                return 140
            default : return 0
        }
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0 :
                let preferenceDescriptionCell = self.paymentsTable.dequeueReusableCellWithIdentifier("preferenceDescriptionCell") as! PreferenceDescriptionTableViewCell
                preferenceDescriptionCell.fillRowWithSettings(self.amount, purchaseTitle: self.purchaseTitle, pictureUrl: nil)
                return preferenceDescriptionCell
            case 1:
                let currentPaymentMethod = self.paymentMethodsSearch[indexPath.row]
                return getCellFor(currentPaymentMethod)
            default :
                let copyrightCell = self.paymentsTable.dequeueReusableCellWithIdentifier("copyrightCell") as! CopyrightTableViewCell
                let separatorLineView = UIView(frame: CGRect(x: 0, y: 139, width: self.view.bounds.size.width, height: 1))
                separatorLineView.layer.zPosition = 1
                separatorLineView.backgroundColor = UIColor().UIColorFromRGB(0xEFEFF4)
                copyrightCell.addSubview(separatorLineView)
                copyrightCell.bringSubviewToFront(separatorLineView)
                return copyrightCell
        }
        
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let paymentSearchItemSelected = self.paymentMethodsSearch[indexPath.row]
        if indexPath.section == 1 {
            self.paymentsTable.deselectRowAtIndexPath(indexPath, animated: true)
            if (paymentSearchItemSelected.children.count > 0) {
                MPFlowController.push(PaymentVaultViewController(amount: self.amount, currencyId : self.currencyId!, purchaseTitle : self.purchaseTitle, paymentMethodSearch: paymentSearchItemSelected.children, paymentMethodSearchParent: paymentSearchItemSelected, title:paymentSearchItemSelected.childrenHeader, callback: { (paymentMethod: PaymentMethod, cardToken: CardToken?, issuer: Issuer?, installments: Int) -> Void in
                    self.callback(paymentMethod: paymentMethod, cardToken: nil, issuer: nil, installments: 1)
                }))
            } else {
                self.optionSelected(paymentSearchItemSelected)
            }
        }
    }
    
    internal func optionSelected(paymentSearchItemSelected : PaymentMethodSearchItem, animated: Bool = true){
        // Disable selection if connection's slow
        self.paymentsTable.allowsSelection = false
        if paymentSearchItemSelected.type == PaymentMethodSearchItemType.PAYMENT_TYPE {
            let paymentTypeId = PaymentTypeId(rawValue: paymentSearchItemSelected.idPaymentMethodSearchItem)
            
            if paymentTypeId!.isCard() {
                self.cardFlow(PaymentType(paymentTypeId: paymentTypeId!), animated : animated)
            } else {
                MPFlowController.push(MPStepBuilder.startPaymentMethodsStep([PaymentTypeId(rawValue: paymentSearchItemSelected.idPaymentMethodSearchItem)!], callback: { (paymentMethod : PaymentMethod) -> Void in
                    //TODO : verificar que con off issuer/installments es asi
                    self.callback(paymentMethod: paymentMethod, cardToken: nil, issuer: nil, installments: 1)
                }))
            }
        } else if paymentSearchItemSelected.type == PaymentMethodSearchItemType.PAYMENT_METHOD {
            if paymentSearchItemSelected.idPaymentMethodSearchItem == "account_money" {
                //MP wallet
            } else if paymentSearchItemSelected.idPaymentMethodSearchItem == "bitcoin" {
                
            } else {
                // Offline Payment Method
                MPServicesBuilder.getPaymentMethods({ (paymentMethods) -> Void in
                        if paymentMethods?.count > 0 {
                            let paymentMethodSelected = paymentMethods?.filter({ return $0._id == paymentSearchItemSelected.idPaymentMethodSearchItem})[0]
                            paymentMethodSelected!.comment = paymentSearchItemSelected.comment
                            self.callback(paymentMethod: paymentMethodSelected!, cardToken: nil, issuer: nil, installments: 1)
                        } else {
                            //TODO
                        }
                    }, failure: { (error) -> Void in
                        //TODO
                })
            }
        }
    
    }
    
    private func loadPaymentMethodGroups(){
        if paymentMethodsSearch == nil {
            MPServicesBuilder.searchPaymentMethods(self.excludedPaymentTypes, excludedPaymentMethods: self.excludedPaymentMethods, success: { (paymentMethodSearchResponse: PaymentMethodSearch) -> Void in
                
                self.paymentMethodsSearch = paymentMethodSearchResponse.groups
                if self.paymentMethodsSearch.count == 1 {
                    self.optionSelected(self.paymentMethodsSearch[0], animated: false)
                }
                self.paymentsTable.delegate = self
                self.paymentsTable.dataSource = self
                
                self.paymentsTable.reloadData()
                }, failure: { (error) -> Void in
                    //TODO
            })
        } else {
            self.paymentsTable.delegate = self
            self.paymentsTable.dataSource = self
            
            self.paymentsTable.reloadData()
        }
    
    }
    
    /** Logica para determinar que xib dibujar como celda segun el contenido del PaymentMethodSearchItem **/
    private func getCellFor(currentPaymentMethodItem : PaymentMethodSearchItem) -> UITableViewCell {
        
        let iconImage = MercadoPago.getImage(currentPaymentMethodItem.idPaymentMethodSearchItem)
        let tintColor = self.tintColor && (!currentPaymentMethodItem.isPaymentMethod() || currentPaymentMethodItem.isBitcoin())
        
        if iconImage != nil {
            if currentPaymentMethodItem.isPaymentMethod() && !currentPaymentMethodItem.isBitcoin() {
                if currentPaymentMethodItem.comment != nil && currentPaymentMethodItem.comment!.characters.count > 0 {
                    let offlinePaymentCell = self.paymentsTable.dequeueReusableCellWithIdentifier("offlinePaymentMethodCell") as! OfflinePaymentMethodCell
                    offlinePaymentCell.fillRowWithPaymentMethod(currentPaymentMethodItem, image: iconImage!)
                    return offlinePaymentCell
                } else {
                    let offlinePaymentCellWithImage = self.paymentsTable.dequeueReusableCellWithIdentifier("offlinePaymentWithImageCell") as! PaymentMethodImageViewCell
                    offlinePaymentCellWithImage.paymentMethodImage.image = iconImage
                    return offlinePaymentCellWithImage
                }
            } else {
                let paymentSearchCell = self.paymentsTable.dequeueReusableCellWithIdentifier("paymentSearchCell") as! PaymentSearchCell
                paymentSearchCell.fillRowWithPayment(currentPaymentMethodItem, iconImage : iconImage!, tintColor: tintColor)
                paymentSearchCell.separatorInset = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
                
                return paymentSearchCell
            }

        }
        
        if currentPaymentMethodItem.comment != nil && currentPaymentMethodItem.comment?.characters.count > 0 {
            let paymentSearchTitleAndCommentCell = self.paymentsTable.dequeueReusableCellWithIdentifier("paymentTitleAndCommentCell") as! PaymentTitleAndCommentViewCell
            paymentSearchTitleAndCommentCell.fillRowWith(currentPaymentMethodItem.description, paymentComment: currentPaymentMethodItem.comment!)
            return paymentSearchTitleAndCommentCell
        }
        
        let paymentSearchCell = self.paymentsTable.dequeueReusableCellWithIdentifier("paymentSearchTitleCell") as! PaymentTitleViewCell
        paymentSearchCell.paymentTitle.text = currentPaymentMethodItem.description
        return paymentSearchCell

    }
    
    internal func cardFlow(paymentType: PaymentType, animated : Bool){
        MPFlowController.push(MPStepBuilder.startCreditCardForm(paymentType, amount: self.amount, callback: { (paymentMethod, cardToken, issuer, installment) -> Void in
            //TODO
            self.callback!(paymentMethod: paymentMethod, cardToken: cardToken, issuer: issuer, installments: 1)
        }))
    }

    private func registerAllCells(){
        let paymentMethodSearchNib = UINib(nibName: "PaymentSearchCell", bundle: self.bundle)
        let paymentSearchTitleCell = UINib(nibName: "PaymentTitleViewCell", bundle: self.bundle)
        let offlinePaymentMethodCell = UINib(nibName: "OfflinePaymentMethodCell", bundle: self.bundle)
        let preferenceDescriptionCell = UINib(nibName: "PreferenceDescriptionTableViewCell", bundle: self.bundle)
        let paymentTitleAndCommentCell = UINib(nibName: "PaymentTitleAndCommentViewCell", bundle: self.bundle)
        let offlinePaymentWithImageCell = UINib(nibName: "PaymentMethodImageViewCell", bundle: self.bundle)
        let copyrightCell = UINib(nibName: "CopyrightTableViewCell", bundle: self.bundle)
        
        self.paymentsTable.registerNib(paymentTitleAndCommentCell, forCellReuseIdentifier: "paymentTitleAndCommentCell")
        self.paymentsTable.registerNib(paymentMethodSearchNib, forCellReuseIdentifier: "paymentSearchCell")
        self.paymentsTable.registerNib(paymentSearchTitleCell, forCellReuseIdentifier: "paymentSearchTitleCell")
        self.paymentsTable.registerNib(offlinePaymentMethodCell, forCellReuseIdentifier: "offlinePaymentMethodCell")
        self.paymentsTable.registerNib(preferenceDescriptionCell, forCellReuseIdentifier: "preferenceDescriptionCell")
        self.paymentsTable.registerNib(offlinePaymentWithImageCell, forCellReuseIdentifier: "offlinePaymentWithImageCell")
        self.paymentsTable.registerNib(copyrightCell, forCellReuseIdentifier: "copyrightCell")
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func togglePreferenceDescription(){
        self.togglePreferenceDescription(self.paymentsTable)
    }

    
}
