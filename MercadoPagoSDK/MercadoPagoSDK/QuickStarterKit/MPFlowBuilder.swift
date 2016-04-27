//
//  MPFlowBuilder.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

public class MPFlowBuilder : NSObject {
    
    @available(*, deprecated=2.0, message="Use startCheckoutViewController instead")
    public class func startVaultViewController(amount: Double, supportedPaymentTypes: Set<PaymentTypeId>?, callback: (paymentMethod: PaymentMethod, tokenId: String?, issuer: Issuer?, installments: Int) -> Void) -> VaultViewController {
        
        return VaultViewController(amount: amount, supportedPaymentTypes: supportedPaymentTypes, callback: callback)
        
    }

    
    public class func startCheckoutViewController(preference: CheckoutPreference, callback: (Payment) -> Void) -> UINavigationController {
            return MPFlowBuilder.startPaymentVaultInCheckout(preference.getAmount(), paymentSettings: PaymentSettings(preferencePaymentMethods: preference.paymentMethodsSettings!), callback: { (paymentMethod, token, issuer, installments) -> Void in
                
                let checkoutVC = CheckoutViewController(preference: preference, callback: { (payment : Payment) -> Void in
                    callback(payment)
                })
                checkoutVC.paymentMethod = paymentMethod
                checkoutVC.installments = installments
                checkoutVC.issuer = issuer
                checkoutVC.token = token
                checkoutVC.callback = {(payment: Payment) -> Void in
                    checkoutVC.dismissViewControllerAnimated(true, completion: { () -> Void in
                        callback(payment)
                    })
                }

                MPFlowController.push(checkoutVC)
            })
    }
    
    public class func startPaymentVaultViewController(amount: Double, paymentSettings : PaymentSettings, callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void) -> UINavigationController {
        
        
        let paymentVault = PaymentVaultViewController(amount: amount,paymentSettings : paymentSettings, callback: callback)
        
        paymentVault.callback = {(paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void in
            paymentVault.dismissViewControllerAnimated(true, completion: { () -> Void in
                callback(paymentMethod: paymentMethod, token: token, issuer: issuer, installments: installments)
            })
        }
        paymentVault.modalTransitionStyle = .CrossDissolve
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }
    
    internal class func startPaymentVaultInCheckout(amount: Double, paymentSettings: PaymentSettings?, callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void) -> UINavigationController {
        
        let paymentVault = PaymentVaultViewController(amount: amount, paymentSettings: paymentSettings, callback: callback)
        paymentVault.modalTransitionStyle = .CrossDissolve
        
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }

    
    /*
    public class func startCardFlow(paymentSettings: PaymentSettings? , amount: Double, callback: (paymentMethod: PaymentMethod, token: Token? ,  issuer: Issuer?, payerCost: PayerCost?) -> Void) -> UINavigationController {
    
    
    let cardVC = MPStepBuilder.startCreditCardForm(PaymentType(paymentTypeId: (paymentSettings?.defaultPaymentTypeId)!).paymentSettingAssociated() , amount: amount, callback: { (paymentMethod, token, issuer, installment) -> Void in
    let payerCostDefaulty : PayerCost? = installment!.containsInstallment(paymentSettings!.defaultInstalment!)
    if(payerCostDefaulty != nil){
    callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost:payerCostDefaulty)
    MPFlowController.sharedInstance.navigationController?.dismissViewControllerAnimated(false, completion: { () -> Void in
    
    })
    return
    }
    if ((installment == nil)||(installment?.payerCosts == nil)||(installment?.numberOfPayerCostToShow(paymentSettings!.maxAcceptedInstalment) < 2)){
    if ((installment != nil) && (installment!.payerCosts != nil) && (installment!.payerCosts.count > 0) ){
    callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost: installment?.payerCosts[0])
    }else{
    callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost:nil)
    }
    
    MPFlowController.sharedInstance.navigationController?.dismissViewControllerAnimated(false, completion: { () -> Void in
    print("Ya esta!")
    })
    }else{
    let step : PayerCostViewController = MPStepBuilder.startPayerCostForm(paymentMethod, issuer: issuer, token: token!, amount: amount, minInstallments: paymentSettings?.maxAcceptedInstalment, callback: { (payerCost) -> Void in
    callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost: payerCost)
    })
    
    
    MPFlowController.sharedInstance.navigationController?.pushViewController(step, animated: false)
    
    //  step.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: step, action: "backTapped:")
    
    }
    })
    
    cardVC.modalTransitionStyle = .CrossDissolve
    
    
    
    return MPFlowController.createNavigationControllerWith(cardVC)
    
    
    }

    */
    
    public class func startCardFlow(paymentSettings: PaymentSettings? , amount: Double, callback: (paymentMethod: PaymentMethod, token: Token? ,  issuer: Issuer?, payerCost: PayerCost?) -> Void) -> UINavigationController {
        
        
        let cardVC = MPStepBuilder.startCreditCardForm(PaymentType(paymentTypeId: (paymentSettings?.defaultPaymentTypeId)!).paymentSettingAssociated() , amount: amount, callback: { (paymentMethod, token, issuer, installment) -> Void in
            
            let step = MPStepBuilder.startCreditCardForm(PaymentType(paymentTypeId: (paymentSettings?.defaultPaymentTypeId)!).paymentSettingAssociated() , amount: amount, token:token, callback: { (paymentMethod, token, issuer, installment) -> Void in
                })
            
                MPFlowController.sharedInstance.navigationController?.pushViewController(step, animated: false)
           
        })
        
        cardVC.modalTransitionStyle = .CrossDissolve
        
        
        
        return MPFlowController.createNavigationControllerWith(cardVC)
        
        
    }

}
