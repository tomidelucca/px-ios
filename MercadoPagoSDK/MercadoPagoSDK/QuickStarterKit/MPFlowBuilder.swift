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
            let checkoutVC = CheckoutViewController(preference: preference, callback: { (payment : Payment) -> Void in
            callback(payment)
        })
        return MPFlowController.createNavigationControllerWith(checkoutVC)
    }
    
    public class func startPaymentVaultViewController(amount: Double, paymentPreference : PaymentPreference, purchaseTitle : String!, currencyId : String!, callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void) -> UINavigationController {
        
        let paymentVault = PaymentVaultViewController(amount: amount, paymentSettings : paymentPreference, purchaseTitle: purchaseTitle, currencyId: currencyId, callback: callback)

        paymentVault.callback = {(paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void in
            paymentVault.dismissViewControllerAnimated(true, completion: { () -> Void in
                callback(paymentMethod: paymentMethod, token: token, issuer: issuer, installments: installments)
            })
        }
        
        paymentVault.modalTransitionStyle = .CrossDissolve
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }
    
    internal class func startPaymentVaultInCheckout(amount: Double, paymentSettings: PaymentPreference?, paymentMethodSearch : PaymentMethodSearch, callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, installments: Int) -> Void) -> UINavigationController {
        
        let paymentVault = PaymentVaultViewController(amount: amount, paymentSettings: paymentSettings, paymentMethodSearchItem: paymentMethodSearch.groups, paymentMethods: paymentMethodSearch.paymentMethods, tintColor: true, callback: callback)
        
        paymentVault.modalTransitionStyle = .CrossDissolve
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }

    
    
    public class func startCardFlow(paymentSettings: PaymentPreference? , amount: Double, callback: (paymentMethod: PaymentMethod, token: Token? ,  issuer: Issuer?, payerCost: PayerCost?) -> Void) -> UINavigationController {
    
    
        let cardVC = MPStepBuilder.startCreditCardForm(PaymentType(paymentTypeId: (paymentSettings?.defaultPaymentTypeId)!).paymentSettingAssociated() , amount: amount, callback: { (paymentMethod, token, issuer, installment) -> Void in
            let payerCostDefaulty : PayerCost? = installment!.containsInstallment(paymentSettings!.defaultInstallments!)
            if(payerCostDefaulty != nil){
                callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost:payerCostDefaulty)
                
                return
            }
            if ((installment == nil)||(installment?.payerCosts == nil)||(installment?.numberOfPayerCostToShow(paymentSettings!.maxAcceptedInstallments) < 2)){
                if ((installment != nil) && (installment!.payerCosts != nil) && (installment!.payerCosts.count > 0) ){
                    callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost: installment?.payerCosts[0])
                }else{
                    callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost:nil)
                }
    
               
            }else{
                let step : PayerCostViewController = MPStepBuilder.startPayerCostForm(paymentMethod, issuer: issuer, token: token!, amount: amount, minInstallments: paymentSettings!.maxAcceptedInstallments, callback: { (payerCost) -> Void in
                    callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost: payerCost)
                })

    
    //  step.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: step, action: "backTapped:")
    
    }
    })
    
    cardVC.modalTransitionStyle = .CrossDissolve
    
    
    
    return MPFlowController.createNavigationControllerWith(cardVC)
    
    
    }

 

    
    /*public class func startCardFlow(paymentSettings: PaymentPreference? , amount: Double, callback: (paymentMethod: PaymentMethod, token: Token? ,  issuer: Issuer?, payerCost: PayerCost?) -> Void) -> UINavigationController {
        

        let cardVC = MPStepBuilder.startCreditCardForm(paymentSettings , amount: amount, callback: { (paymentMethod, token, issuer, installment) -> Void in
            
            let step = MPStepBuilder.startCreditCardForm(PaymentType(paymentTypeId: paymentSettings.defaultPaymentTypeId , amount: amount, token:token, callback: { (paymentMethod, token, issuer, installment) -> Void in

                })

                MPFlowController.sharedInstance.currentNavigationController?.pushViewController(step, animated: true)


           
        })
        
        cardVC.modalTransitionStyle = .CrossDissolve
        return MPFlowController.createNavigationControllerWith(cardVC)
        
        
    }*/

}
