//
//  CheckoutViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 13/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CheckoutViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var preference : CheckoutPreference?
    var publicKey : String!
    var accessToken : String!
    var bundle : NSBundle? = MercadoPago.getBundle()
    var callback : (MerchantPayment -> Void)!
    var paymentMethod : PaymentMethod?
    var installments : Int?
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
        let checkoutPaymentCell = UINib(nibName: "CheckoutPaymentCellTableViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(checkoutPaymentCell, forCellReuseIdentifier: "checkoutPaymentCell")
        
        self.checkoutTable.delegate = self
        self.checkoutTable.dataSource = self
        
        self.confirmPaymentButton.layer.cornerRadius = 6
        self.confirmPaymentButton.clipsToBounds = true
        self.confirmPaymentButton.addTarget(self, action: "confirmPayment", forControlEvents: UIControlEvents.TouchDown)

        self.cancelPaymentButton.addTarget(self, action: "cancelPayment", forControlEvents: UIControlEvents.TouchDown)
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
        let vaultVC = MPFlowBuilder.startPaymentVaultViewController((preference?.getAmount())!, excludedPaymentTypes: preference!.getExcludedPaymentTypes(), excludedPaymentMethods: preference!.getExcludedPaymentMethods()) { (paymentMethod, tokenId, issuer, installments) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
            self.paymentMethod = paymentMethod
            self.tokenId = tokenId
            self.issuer = issuer
            self.installments = installments
            self.checkoutTable.reloadData()
        }
        self.navigationController?.pushViewController(vaultVC, animated: true)
    }
    
    internal func confirmPayment(){
        let merchantPayment = MerchantPayment(items: self.preference!.items!, installments: self.installments!, issuer: self.issuer!, tokenId: self.tokenId, paymentMethod: self.paymentMethod!, campaignId: 0)
        MercadoPago.createMPPayment(merchantPayment, success: { (payment) -> Void in
            MPStepBuilder.startCongratsStep(payment, paymentMethod: self.paymentMethod!)
            }) { (error) -> Void in
                //TODO
                
        }
    }
    
    internal func cancelPayment(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
