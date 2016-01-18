//
//  CheckoutViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 13/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CheckoutViewController: UIViewController {

    var preference : CheckoutPreference!
    var vaultVC : VaultViewController?
    var callback : ((Payment, PaymentMethod) -> Void)?
    
    init(preference : CheckoutPreference, callback : ((Payment, PaymentMethod) -> Void)){
        super.init(nibName: "CheckoutViewController", bundle: nil)
        self.preference = preference
        self.callback = callback
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        vaultVC = MPFlowBuilder.startVaultViewController(preference!.getAmount(), supportedPaymentTypes: preference.getPaymentTypeIdsSupported()) { (paymentMethod, tokenId, issuer, installments) -> Void in
            
            let merchantPayment : MerchantPayment = MerchantPayment(items: self.preference.items!, installments: installments, cardIssuer: issuer!, tokenId: tokenId!, paymentMethod: paymentMethod, campaignId: 0)
            
            MPServicesBuilder.createPayment(MPServicesBuilder.MP_API_BASE_URL, merchantPaymentUri: MPServicesBuilder.MP_PAYMENTS_URI, payment: merchantPayment, success: { (payment) -> Void in
                self.navigationController?.pushViewController(MPStepBuilder.startCongratsStep(payment, paymentMethod: paymentMethod), animated: true)
                }, failure: { (error) -> Void in
                    MercadoPago.showAlertViewWithError(error, nav: self.navigationController)
                    self.navigationController?.popToRootViewControllerAnimated(true)
            })
           
        }

        self.navigationController?.pushViewController(self.vaultVC!, animated: true)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
