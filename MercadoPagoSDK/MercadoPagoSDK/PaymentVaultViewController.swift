//
//  PaymentVaultViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentVaultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var merchantBaseUrl : String!
    var merchantAccessToken : String!
    var publicKey : String!
    var amount : Double!
    var excludedPaymentTypes : Set<PaymentTypeId>!
    var excludedPaymentMethods : [String]!
    var callback : ((paymentMethod: PaymentMethod, tokenId: String?, issuer: Issuer?, installments: Int) -> Void)!
    var paymentMethodsSearch : [PaymentMethodSearchItem]!
    var paymentMethodSearchParent : PaymentMethodSearchItem?
    
    var bundle = MercadoPago.getBundle()
    
    var paymentSearchCell : PaymentSearchCell!
    
    private var tintColor = true
    
    @IBOutlet weak var paymentsTable: UITableView!
    
    init(amount: Double, paymentMethodSearch : [PaymentMethodSearchItem], paymentMethodSearchParent : PaymentMethodSearchItem, title: String!, callback: (paymentMethod: PaymentMethod, tokenId: String?, issuer: Issuer?, installments: Int) -> Void) {
        super.init(nibName: "PaymentVaultViewController", bundle: bundle)
        self.merchantBaseUrl = MercadoPagoContext.baseURL()
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()
        self.publicKey = MercadoPagoContext.publicKey()
        self.title = title
        self.tintColor = false
        self.amount = amount
        self.paymentMethodSearchParent = paymentMethodSearchParent
        self.paymentMethodsSearch = paymentMethodSearch
        self.callback = callback
    }
    
    init(amount: Double, excludedPaymentTypes: Set<PaymentTypeId>?, excludedPaymentMethods : [String]?, callback: (paymentMethod: PaymentMethod, tokenId: String?, issuerId: Issuer?, installments: Int) -> Void) {
        super.init(nibName: "PaymentVaultViewController", bundle: bundle)
        self.merchantBaseUrl = MercadoPagoContext.baseURL()
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()
        self.publicKey = MercadoPagoContext.publicKey()
        self.amount = amount
        self.excludedPaymentTypes = excludedPaymentTypes
        self.excludedPaymentMethods = excludedPaymentMethods
        self.callback = callback
    }
    
    required  public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if self.title == nil || self.title!.isEmpty {
            self.title = "¿Cómo quieres pagar?"
        }
        
        
        let paymentMethodSearchNib = UINib(nibName: "PaymentSearchCell", bundle: self.bundle)
        let paymentSearchTitleNib = UINib(nibName: "PaymentTitleViewCell", bundle: self.bundle)
        let offlinePaymentMethodNib = UINib(nibName: "OfflinePaymentMethodCell", bundle: self.bundle)
        
        self.paymentsTable.registerNib(paymentMethodSearchNib, forCellReuseIdentifier: "paymentSearchCell")
        self.paymentsTable.registerNib(paymentSearchTitleNib, forCellReuseIdentifier: "paymentSearchTitleNib")
        self.paymentsTable.registerNib(offlinePaymentMethodNib, forCellReuseIdentifier: "offlinePaymentMethodNib")
        
        if paymentMethodsSearch == nil {
            MPServicesBuilder.searchPaymentMethods(self.excludedPaymentTypes, excludedPaymentMethods: self.excludedPaymentMethods, success: { (paymentMethodSearchResponse: PaymentMethodSearch) -> Void in

                self.paymentMethodsSearch = paymentMethodSearchResponse.groups
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
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentMethodsSearch.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentPaymentMethod = self.paymentMethodsSearch[indexPath.row]
        let iconImage = MercadoPago.getImage(currentPaymentMethod.idPaymentMethodSearchItem)
        let isPaymentMethod = currentPaymentMethod.type == PaymentMethodSearchItemType.PAYMENT_METHOD
        let tintColor = self.tintColor && (!isPaymentMethod || currentPaymentMethod.isBitcoin())
        
        
        if iconImage != nil {
            if self.paymentMethodSearchParent != nil && self.paymentMethodSearchParent!.isOfflinePayment(){
                let offlinePaymentCell = self.paymentsTable.dequeueReusableCellWithIdentifier("offlinePaymentMethodNib") as! OfflinePaymentMethodCell
                offlinePaymentCell.iconImage.image = iconImage!
                offlinePaymentCell.comment.text = currentPaymentMethod.comment!
                return offlinePaymentCell
            } else {
                let paymentSearchCell = self.paymentsTable.dequeueReusableCellWithIdentifier("paymentSearchCell") as! PaymentSearchCell
                paymentSearchCell.fillRowWithPayment(self.paymentMethodsSearch[indexPath.row], iconImage : iconImage!, tintColor: tintColor)
            
                return paymentSearchCell
            }
        }
        
        let paymentSearchCell = self.paymentsTable.dequeueReusableCellWithIdentifier("paymentSearchTitleNib") as! PaymentTitleViewCell
        paymentSearchCell.paymentTitle.text = currentPaymentMethod.description
        return paymentSearchCell
        
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let paymentSearchItemSelected = self.paymentMethodsSearch[indexPath.row]
        self.paymentsTable.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        if (paymentSearchItemSelected.children.count > 0) {
            self.navigationController?.popViewControllerAnimated(true)
            self.navigationController?.pushViewController(PaymentVaultViewController(amount: self.amount, paymentMethodSearch: paymentSearchItemSelected.children, paymentMethodSearchParent: paymentSearchItemSelected, title:paymentSearchItemSelected.childrenHeader, callback: self.callback!), animated: true)
        } else  if paymentSearchItemSelected.type == PaymentMethodSearchItemType.PAYMENT_TYPE {
            
            let paymentTypeId = PaymentTypeId(rawValue: paymentSearchItemSelected.idPaymentMethodSearchItem)
            
            if paymentTypeId!.isCard() {
                self.cardFlow(PaymentType(paymentTypeId: paymentTypeId!))
            } else {
                self.navigationController?.pushViewController(MPStepBuilder.startPaymentMethodsStep([PaymentTypeId(rawValue: paymentSearchItemSelected.idPaymentMethodSearchItem)!], callback: { (paymentMethod : PaymentMethod) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    //TODO : verificar que con off issuer/installments es asi
                    self.callback!(paymentMethod: paymentMethod, tokenId: nil, issuer: nil, installments: 1)
                }), animated: true)
            }
        } else if paymentSearchItemSelected.type == PaymentMethodSearchItemType.PAYMENT_METHOD {
            if paymentSearchItemSelected.idPaymentMethodSearchItem == "account_money" {
                //wallet
            } else {
                //if atm-ticket -bitcoin
                let paymentMethod = PaymentMethod()
                paymentMethod.name = paymentSearchItemSelected.description
                self.callback!(paymentMethod: paymentMethod, tokenId: nil, issuer: nil, installments: 1)
                //else if cc
            }
        }
    }
    
    public func cardFlow(paymentType: PaymentType){
        self.navigationController?.pushViewController(MPStepBuilder.startCreditCardForm(paymentType, callback: { (paymentMethod, token, issuer, installment) -> Void in
            
        }), animated: true)
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if paymentMethodSearchParent != nil && paymentMethodSearchParent!.isOfflinePayment() {
            return 80
        }
        return 52
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
