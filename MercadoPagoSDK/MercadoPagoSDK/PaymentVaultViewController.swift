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
    var excludedPaymentMethods : [PaymentMethod]!
    var callback : ((paymentMethod: PaymentMethod, tokenId: String?, issuer: Issuer?, installments: Int) -> Void)!
    var paymentMethodsSearch : [PaymentMethodSearchItem]!
    
    var bundle = MercadoPago.getBundle()
    
    
    var paymentSearchCell : PaymentSearchRowTableViewCell!
    
    @IBOutlet weak var paymentsTable: UITableView!
    
    init(amount: Double, paymentMethodSearch : [PaymentMethodSearchItem], callback: (paymentMethod: PaymentMethod, tokenId: String?, issuer: Issuer?, installments: Int) -> Void) {
        super.init(nibName: "PaymentVaultViewController", bundle: bundle)
        self.merchantBaseUrl = MercadoPagoContext.baseURL()
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()
        self.publicKey = MercadoPagoContext.publicKey()

        self.amount = amount
        self.paymentMethodsSearch = paymentMethodSearch
        self.callback = callback
    }
    
    init(amount: Double, excludedPaymentTypes: Set<PaymentTypeId>?, excludedPaymentMethods : [PaymentMethod]?, callback: (paymentMethod: PaymentMethod, tokenId: String?, issuerId: Issuer?, installments: Int) -> Void) {
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
        
        let paymentMethodSearchNib = UINib(nibName: "PaymentSearchRowTableViewCell", bundle: self.bundle)
        self.paymentsTable.registerNib(paymentMethodSearchNib, forCellReuseIdentifier: "paymentSearchCell")
        self.paymentSearchCell = self.paymentsTable.dequeueReusableCellWithIdentifier("paymentSearchCell") as! PaymentSearchRowTableViewCell
        
        if paymentMethodsSearch == nil {
            let paymentMethodsSearchService = PaymentMethodSearchService()
            paymentMethodsSearchService.getPaymentMethods(nil, excludedPaymentMethods: nil, public_key: self.publicKey!, success: { (paymentMethodSearch : PaymentMethodSearch) -> Void in
                self.paymentMethodsSearch = paymentMethodSearch.groups
                self.paymentsTable.delegate = self
                self.paymentsTable.dataSource = self

                self.paymentsTable.reloadData()
                }) { (error) -> Void in
                    
            }
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
        let paymentSearchCell = self.paymentsTable.dequeueReusableCellWithIdentifier("paymentSearchCell") as! PaymentSearchRowTableViewCell
        paymentSearchCell.fillRowWithPayment(self.paymentMethodsSearch[indexPath.row])
        return paymentSearchCell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let paymentSearchItemSelected = self.paymentMethodsSearch[indexPath.row]
        if (paymentSearchItemSelected.type == PaymentMethodSearchItemType.GROUP) {
            
            self.navigationController?.pushViewController(PaymentVaultViewController(amount: self.amount, paymentMethodSearch: paymentSearchItemSelected.children, callback: self.callback!), animated: true)
        } else  if (paymentSearchItemSelected.type == PaymentMethodSearchItemType.PAYMENT_TYPE) {
            self.navigationController!.pushViewController(MPStepBuilder.getViewForPaymentTypeSelected(PaymentTypeId(rawValue: paymentSearchItemSelected.idPaymentMethodSearchItem)!)!, animated: true)
        } else if (paymentSearchItemSelected.type == PaymentMethodSearchItemType.PAYMENT_METHOD) {
            self.navigationController!.pushViewController(MPStepBuilder.getViewForPaymentMethodSelected(paymentSearchItemSelected)!, animated: true)
        }

    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
