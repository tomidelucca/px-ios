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
    
    /*
    var excludedPaymentTypes : Set<PaymentTypeId>!
    var excludedPaymentMethods : [String]!
    var defaultPaymentMethodId : String?
    var currencyId : String!
    var purchaseTitle : String!
    */
    var paymentSettings : PaymentSettings!
    

    var callback : ((paymentMethod: PaymentMethod, token:Token?, issuer: Issuer?, installments: Int) -> Void)!


    var defaultInstallments : Int?
    var installments : Int?

    var paymentMethods : [PaymentMethod]!
    var currentPaymentMethodSearch : [PaymentMethodSearchItem]!
    var paymentMethodSearchItemParent : PaymentMethodSearchItem?
    
    var bundle = MercadoPago.getBundle()
    
    private var tintColor = true

    
    @IBOutlet weak var paymentsTable: UITableView!
    

    internal init(amount: Double, paymentSettings : PaymentSettings!, paymentMethodSearchItem : [PaymentMethodSearchItem], paymentMethodSearchParent : PaymentMethodSearchItem, paymentMethods : [PaymentMethod], title: String!, callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void) {

        super.init(nibName: "PaymentVaultViewController", bundle: bundle)
        self.merchantBaseUrl = MercadoPagoContext.baseURL() //distinta de null y vacia
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()//Distinta de null y vacio
        //Installment > 0
        
        //Vaidar que no excluyo todos los payment method
        
        self.publicKey = MercadoPagoContext.publicKey()
        self.title = title
        self.tintColor = false
        self.amount = amount // mayor o igual a 0
        self.paymentSettings = paymentSettings
       

        self.paymentMethodSearchItemParent = paymentMethodSearchParent
        self.currentPaymentMethodSearch = paymentMethodSearchItem
        self.paymentMethods = paymentMethods
        self.callback = {(paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void in
            callback(paymentMethod: paymentMethod, token: token, issuer: issuer, installments: installments)

        }
    }
    
    init(amount: Double, paymentSettings : PaymentSettings!, callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void) {
        super.init(nibName: "PaymentVaultViewController", bundle: bundle)
        self.merchantBaseUrl = MercadoPagoContext.baseURL()
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()
        self.publicKey = MercadoPagoContext.publicKey()
        self.amount = amount
        self.paymentSettings = paymentSettings
        self.callback = {(paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void in
            callback(paymentMethod: paymentMethod, token: token, issuer: issuer, installments: installments)
        }
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
        self.loadPaymentMethodSearch()

    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return self.displayPreferenceDescription ? 1 : 0
            case 1:
                return self.currentPaymentMethodSearch.count
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
                let currentPaymentMethodSearchItem = self.currentPaymentMethodSearch[indexPath.row]
                if currentPaymentMethodSearchItem.isPaymentMethod() && !currentPaymentMethodSearchItem.isBitcoin() {
                    return 80
                }
                return 52
            case 2:
                return 100
            default : return 0
        }
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0 :
                let preferenceDescriptionCell = self.paymentsTable.dequeueReusableCellWithIdentifier("preferenceDescriptionCell") as! PreferenceDescriptionTableViewCell
                preferenceDescriptionCell.fillRowWithSettings(self.amount, purchaseTitle: self.paymentSettings.purchaseTitle, pictureUrl: nil)
                return preferenceDescriptionCell
            case 1:
                let currentPaymentMethod = self.currentPaymentMethodSearch[indexPath.row]
                
                let paymentMethodCell = getCellFor(currentPaymentMethod)
                // Add shadow effect to last cell in table
                if (indexPath.row == self.currentPaymentMethodSearch.count - 1) {
                    paymentMethodCell.clipsToBounds = false
                    paymentMethodCell.layer.masksToBounds = false
                    paymentMethodCell.layer.shadowOffset = CGSizeMake(0, 1)
                    paymentMethodCell.layer.shadowColor = UIColor(red: 153, green: 153, blue: 153).CGColor
                    paymentMethodCell.layer.shadowRadius = 1
                    paymentMethodCell.layer.shadowOpacity = 0.6
                }
                return paymentMethodCell
            default :
                let copyrightCell = self.paymentsTable.dequeueReusableCellWithIdentifier("copyrightCell") as! CopyrightTableViewCell
                return copyrightCell.drawCell(true, width: self.view.bounds.width)
        }
        
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let paymentSearchItemSelected = self.currentPaymentMethodSearch[indexPath.row]
        if indexPath.section == 1 {
            self.paymentsTable.deselectRowAtIndexPath(indexPath, animated: true)
            if (paymentSearchItemSelected.children.count > 0) {
                MPFlowController.push(PaymentVaultViewController(amount: self.amount, paymentSettings: paymentSettings, paymentMethodSearchItem: paymentSearchItemSelected.children, paymentMethodSearchParent: paymentSearchItemSelected, paymentMethods : self.paymentMethods, title:paymentSearchItemSelected.childrenHeader, callback: { (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void in
                    self.callback(paymentMethod: paymentMethod, token: nil, issuer: nil, installments: 1)
                }))
            } else {
                self.optionSelected(paymentSearchItemSelected)
            }

        }
    }
    
    internal func optionSelected(paymentSearchItemSelected : PaymentMethodSearchItem, animated: Bool = true) {
        // Disable selection if connection's slow
        self.paymentsTable.allowsSelection = false
        if paymentSearchItemSelected.type == PaymentMethodSearchItemType.PAYMENT_TYPE {
            let paymentTypeId = PaymentTypeId(rawValue: paymentSearchItemSelected.idPaymentMethodSearchItem)
            
            if paymentTypeId!.isCard() {
                self.cardFlow(PaymentType(paymentTypeId: paymentTypeId!), animated : animated)
            } else {
                MPFlowController.push(MPStepBuilder.startPaymentMethodsStep([PaymentTypeId(rawValue: paymentSearchItemSelected.idPaymentMethodSearchItem)!], callback: { (paymentMethod : PaymentMethod) -> Void in
                    //TODO : verificar que con off issuer/installments es asi
                    self.callback(paymentMethod: paymentMethod, token: nil, issuer: nil, installments: 1)
                }))
            }
        } else if paymentSearchItemSelected.type == PaymentMethodSearchItemType.PAYMENT_METHOD {
            if paymentSearchItemSelected.idPaymentMethodSearchItem == PaymentTypeId.ACCOUNT_MONEY.rawValue {
                //MP wallet
            } else if paymentSearchItemSelected.idPaymentMethodSearchItem == PaymentTypeId.BITCOIN.rawValue {
                
            } else {
                // Offline Payment Method

                let offlinePaymentMethodSelected = self.paymentMethods.filter({ (paymentMethod : PaymentMethod) -> Bool in
                    return paymentMethod._id == paymentSearchItemSelected.idPaymentMethodSearchItem

                })
                if offlinePaymentMethodSelected.isEmpty || offlinePaymentMethodSelected.count != 1 {
                    //TODO error
                } else {
                    offlinePaymentMethodSelected[0].comment = paymentSearchItemSelected.comment
                    self.callback(paymentMethod: offlinePaymentMethodSelected[0], token:nil, issuer: nil, installments: 1)
                }
            }
        }
    
    }
    
    private func loadPaymentMethodSearch(){
        if self.currentPaymentMethodSearch == nil {
            MPServicesBuilder.searchPaymentMethods(self.paymentSettings.excludedPaymentTypesIds, excludedPaymentMethods: self.paymentSettings.excludedPaymentMethodsIds, success: { (paymentMethodSearchResponse: PaymentMethodSearch) -> Void in
                self.paymentMethods = paymentMethodSearchResponse.paymentMethods
                self.currentPaymentMethodSearch = paymentMethodSearchResponse.groups
                if self.currentPaymentMethodSearch.count == 1 {
                    self.optionSelected(self.currentPaymentMethodSearch[0], animated: false)
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
        MPFlowController.push(MPStepBuilder.startCreditCardForm(paymentType.paymentSettingAssociated(), amount: self.amount, callback: { (paymentMethod, token, issuer, installment) -> Void in
            //TODO
            self.callback!(paymentMethod: paymentMethod, token: token, issuer: issuer, installments: 1)
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
