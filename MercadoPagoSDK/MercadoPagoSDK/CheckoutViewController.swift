//
//  CheckoutViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 13/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CheckoutViewController: MercadoPagoUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var preference : CheckoutPreference?
    var publicKey : String!
    var accessToken : String!
    var bundle : NSBundle? = MercadoPago.getBundle()
    var callback : (MerchantPayment -> Void)!
    var paymentMethod : PaymentMethod?
    var installments : Int = 0
    var issuer : Issuer?
    var tokenId : String?
    
    @IBOutlet weak var checkoutTable: UITableView!
    @IBOutlet weak var confirmPaymentButton: UIButton!
    
    @IBOutlet weak var cancelPaymentButton: UIButton!
    
    init(preference : CheckoutPreference, callback : (MerchantPayment -> Void)){
        super.init(nibName: "CheckoutViewController", bundle: MercadoPago.getBundle())
        self.preference = preference
        self.publicKey = MercadoPagoContext.publicKey()
        self.accessToken = MercadoPagoContext.merchantAccessToken()
        self.callback = callback
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "¿Cómo quieres pagar?".localized

        let checkoutPaymentCell = UINib(nibName: "CheckoutPaymentCellTableViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(checkoutPaymentCell, forCellReuseIdentifier: "checkoutPaymentCell")
        
        self.checkoutTable.delegate = self
        self.checkoutTable.dataSource = self

        self.confirmPaymentButton.layer.cornerRadius = 6
        self.confirmPaymentButton.clipsToBounds = true
        self.confirmPaymentButton.addTarget(self, action: "confirmPayment", forControlEvents: UIControlEvents.TouchDown)

        self.cancelPaymentButton.addTarget(self, action: "cancelPayment", forControlEvents: UIControlEvents.TouchDown)
        
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        self.navigationItem.leftBarButtonItem?.action = Selector("clearMercadoPagoStyle")
        self.navigationItem.leftBarButtonItem?.target = self
            
            
        self.startPaymentVault()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("checkoutPaymentCell", forIndexPath: indexPath) as! CheckoutPaymentCellTableViewCell
    
        if self.paymentMethod != nil {
            //TODO : complete flow
            cell.paymentDescription.text = self.paymentMethod!.name
            cell.paymentIcon.image = MercadoPago.getImage(self.paymentMethod!.name.lowercaseString)
            self.confirmPaymentButton.hidden = false
        } else {
            cell.paymentDescription.text = "Select payment method..."
            self.confirmPaymentButton.hidden = true
        }
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.checkoutTable.deselectRowAtIndexPath(indexPath, animated: true)
        self.startPaymentVault()
    }

    internal func startPaymentVault(){
        let paymentVault = MPFlowBuilder.startPaymentVaultViewController((preference?.getAmount())!, excludedPaymentTypes: preference!.getExcludedPaymentTypes(), excludedPaymentMethods: preference!.getExcludedPaymentMethods()) { (paymentMethod, tokenId, issuer, installments) -> Void in
            self.paymentMethod = paymentMethod
            self.tokenId = tokenId
            self.issuer = issuer
            self.installments = installments
            
            self.checkoutTable.reloadData()
        }
        
        self.navigationController?.pushViewController(paymentVault, animated: true)
    }
    
    internal func confirmPayment(){
        let payment = Payment()
        payment.transactionAmount = self.preference!.getAmount()
        payment.tokenId = self.tokenId
        payment.issuerId = self.issuer != nil ? self.issuer!._id!.integerValue : 0
        payment.paymentMethodId = self.paymentMethod!._id
        payment._description = "description"
    
        clearMercadoPagoStyle()
        MercadoPago.createMPPayment(payment, success: { (payment) -> Void in
            self.navigationController?.pushViewController(MPStepBuilder.startCongratsStep(payment, paymentMethod: self.paymentMethod!), animated: true)
            }) { (error) -> Void in
                //TODO
                
        }
    }
    
    internal func cancelPayment(){
        clearMercadoPagoStyle()
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    
}
