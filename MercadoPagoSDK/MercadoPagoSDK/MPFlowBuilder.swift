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
    public class func startVaultViewController(amount: Double, paymentPreference : PaymentPreference? = nil, callback: (paymentMethod: PaymentMethod, tokenId: String?, issuer: Issuer?, installments: Int) -> Void) -> VaultViewController {
        MercadoPagoContext.initFlavor3()
        return VaultViewController(amount: amount, paymentPreference: paymentPreference, callback: callback)
        
    }
    
    public class func startCheckoutViewController(preferenceId: String, callback: (Payment) -> Void, callbackCancel : (Void -> Void)? = nil) -> MPNavigationController {
        MercadoPagoContext.initFlavor3()
            let checkoutVC = CheckoutViewController(preferenceId: preferenceId, callback: { (payment : Payment) -> Void in
            callback(payment)
            }, callbackCancel :callbackCancel)
        return MPFlowController.createNavigationControllerWith(checkoutVC)
    }
    
    
    public class func startPaymentVaultViewController(amount: Double, currencyId : String!,paymentPreference : PaymentPreference? = nil, callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, payerCost : PayerCost?) -> Void) -> MPNavigationController {
         MercadoPagoContext.initFlavor2()
        let paymentVault = PaymentVaultViewController(amount: amount, currencyId : currencyId, paymentPreference : paymentPreference, callback: callback)

        paymentVault.callback = {(paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, payerCost : PayerCost?) -> Void in
            paymentVault.dismissViewControllerAnimated(true, completion: { () -> Void in
                callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost: payerCost)
            })
        }
        
        paymentVault.modalTransitionStyle = .CrossDissolve
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }
    
    internal class func startPaymentVaultInCheckout(amount: Double, currencyId : String!, paymentPreference: PaymentPreference?, paymentMethodSearch : PaymentMethodSearch, callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, payerCost : PayerCost?) -> Void) -> MPNavigationController {
        MercadoPagoContext.initFlavor2()
        let paymentVault = PaymentVaultViewController(amount: amount, currencyId : currencyId, paymentPreference: paymentPreference, paymentMethodSearchItem: paymentMethodSearch.groups, paymentMethods: paymentMethodSearch.paymentMethods, tintColor: true, callback: callback)
        
        paymentVault.modalTransitionStyle = .CrossDissolve
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }

    
    
    public class func startCardFlow(paymentPreference: PaymentPreference? = nil  , amount: Double, paymentMethods : [PaymentMethod]? = nil, callback: (paymentMethod: PaymentMethod, token: Token? ,  issuer: Issuer?, payerCost: PayerCost?) -> Void, var callbackCancel : (Void -> Void)? = nil) -> MPNavigationController {
        MercadoPagoContext.initFlavor2()
        var cardVC : MPNavigationController?
        var ccf : CardFormViewController = CardFormViewController()
        
        if (callbackCancel == nil){
            callbackCancel = { cardVC?.dismissViewControllerAnimated(true, completion: { () -> Void in
            }) }
        }
        cardVC = MPStepBuilder.startCreditCardForm(paymentPreference, amount: amount, paymentMethods : paymentMethods, callback: { (paymentMethod, token, issuer) -> Void in
            
            MPServicesBuilder.getInstallments(token!.firstSixDigit, amount: amount, issuer: issuer, paymentMethodId: paymentMethod._id, success: { (installments) -> Void in
                 //(ccf.navigationController as! MPNavigationController).hideLoading()
                let payerCostSelected = paymentPreference?.autoSelectPayerCost(installments![0].payerCosts)
                    if(payerCostSelected == nil){ // Si tiene una sola opcion de cuotas
                        let pcvc = MPStepBuilder.startPayerCostForm(paymentMethod, issuer: issuer, token: token!, amount:amount, paymentPreference: paymentPreference, installment:installments![0] ,callback: { (payerCost) -> Void in
                            callback(paymentMethod: paymentMethod, token: token!, issuer: issuer, payerCost: payerCost)
                        })
                        pcvc.callbackCancel = callbackCancel
                        
                        ccf.navigationController!.pushViewController(pcvc, animated: false)

                    }else{
                         callback(paymentMethod: paymentMethod, token: token!, issuer: issuer, payerCost: payerCostSelected)
                    }

                
                }, failure: { (error) -> Void in
                     (ccf.navigationController as! MPNavigationController).hideLoading()
            })

            
            }, callbackCancel : callbackCancel)
    
        ccf = cardVC?.viewControllers[0] as! CardFormViewController
    
        cardVC!.modalTransitionStyle = .CrossDissolve
        return cardVC!

    }


}
