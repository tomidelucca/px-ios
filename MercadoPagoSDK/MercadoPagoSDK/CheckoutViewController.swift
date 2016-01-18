//
//  CheckoutViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 13/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CheckoutViewController: UIViewController {
    
    var preference : CheckoutPreference?
    var publicKey : String!
    var accessToken : String!
    var bundle : NSBundle? = MercadoPago.getBundle()
    var callback : (MerchantPayment -> Void)!
    
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
        
        //TODO: getCustomer URI for preference_id
        let vaultVC = MPFlowBuilder.startPaymentVaultViewController((preference?.getAmount())!, excludedPaymentTypes: preference!.getExcludedPaymentTypes(), excludedPaymentMethods: preference!.getExcludedPaymentMethods()) { (paymentMethod, tokenId, issuer, installments) -> Void in
            
            let payment = MerchantPayment(items: self.preference!.items!, installments: self.preference!.getInstallments(), issuer: issuer, tokenId: tokenId!, paymentMethod: paymentMethod, campaignId: 0)
            self.callback(payment)
            
        }
        self.navigationController?.pushViewController(vaultVC, animated: true)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
