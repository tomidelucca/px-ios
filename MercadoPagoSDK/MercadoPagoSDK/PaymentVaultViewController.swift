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
    
    var paymentSearchCell : PaymentSearchRowTableViewCell!
    
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
        
        
        let paymentMethodSearchNib = UINib(nibName: "PaymentSearchRowTableViewCell", bundle: self.bundle)
        let paymentSearchTitleNib = UINib(nibName: "PaymentTitleViewCell", bundle: self.bundle)
        
        self.paymentsTable.registerNib(paymentMethodSearchNib, forCellReuseIdentifier: "paymentSearchCell")
        self.paymentsTable.registerNib(paymentSearchTitleNib, forCellReuseIdentifier: "paymentSearchTitleNib")
        
        if paymentMethodsSearch == nil {
            MPServicesBuilder.searchPaymentMethods(self.excludedPaymentTypes, excludedPaymentMethods: self.excludedPaymentMethods, success: { (paymentMethodSearchResponse: PaymentMethodSearch) -> Void in
                //Filter active groups
                self.paymentMethodsSearch = paymentMethodSearchResponse.groups.filter({$0.active})
                
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

        if currentPaymentMethod.iconName != nil {
            let paymentSearchCell = self.paymentsTable.dequeueReusableCellWithIdentifier("paymentSearchCell") as! PaymentSearchRowTableViewCell
            paymentSearchCell.fillRowWithPayment(self.paymentMethodsSearch[indexPath.row], tintColor: self.tintColor)
            
            return paymentSearchCell
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
                //cc form
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
                // TODO: if cc -> necesito el parent/payment type para buscar el pm! :(
                // atm-ticket 
                //if atm-ticket -bitcoin
                let paymentMethod = PaymentMethod()
                paymentMethod.name = paymentSearchItemSelected.description
                self.callback!(paymentMethod: paymentMethod, tokenId: nil, issuer: nil, installments: 1)
                //else if cc
            }
        }
    }
    
    //TODO: reemplazar por nuevo form de tc
    public func creditCardPyamentFlow(paymentMethod: PaymentMethod){
        self.navigationController?.pushViewController(MPStepBuilder.startNewCardStep(paymentMethod, requireSecurityCode: true, callback: { (cardToken) -> Void in
        self.navigationController?.popViewControllerAnimated(true)
        
        if paymentMethod.isIssuerRequired() {
            self.navigationController?.pushViewController(MPStepBuilder.startIssuersStep(paymentMethod, callback: { (issuer) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                MPStepBuilder.startIssuersStep(paymentMethod, callback: { (issuer) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    MPServicesBuilder.getInstallments(cardToken.getBin()!, amount: self.amount, issuer: issuer, paymentTypeId: paymentMethod.paymentTypeId, success: { (installments) -> Void in
                        MPStepBuilder.startInstallmentsStep(installments![0].payerCosts, amount: self.amount, callback: { (payerCost) -> Void in
                            MPServicesBuilder.createNewCardToken(cardToken, success: { (token) -> Void in
                                self.callback!(paymentMethod: paymentMethod, tokenId: token!._id, issuer: issuer, installments: payerCost!.installments)
                                }, failure: { (error) -> Void in
                                    
                            })
                            
                        })
                        }, failure: { (error) -> Void in
                            //TODO
                    })
                })
            }), animated: true)
        } else {
            //TODO
            MPServicesBuilder.getInstallments(cardToken.getBin()!, amount: self.amount, issuer: nil, paymentTypeId: paymentMethod.paymentTypeId, success: { (installments) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                self.navigationController?.pushViewController(MPStepBuilder.startInstallmentsStep(installments![0].payerCosts, amount: self.amount, callback: { (payerCost) -> Void in
                    MPServicesBuilder.createNewCardToken(cardToken, success: { (token) -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                        self.callback!(paymentMethod: paymentMethod, tokenId: token!._id, issuer: nil, installments: payerCost!.installments)
                        }, failure: { (error) -> Void in
                            
                    })
                }), animated: true)
                
                }, failure: { (error) -> Void in
                    //TODO
            })

            }
        }), animated: true)
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
