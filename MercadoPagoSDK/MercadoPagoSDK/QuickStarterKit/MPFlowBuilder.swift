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
    
    public class func startCheckoutViewController(preferenceId: String, callback: (Payment) -> Void) -> UINavigationController {
            let checkoutVC = CheckoutViewController(preferenceId: preferenceId, callback: { (payment : Payment) -> Void in
            callback(payment)
        })
        return MPFlowController.createNavigationControllerWith(checkoutVC)
    }
    
    
    public class func startPaymentVaultViewController(amount: Double, purchaseTitle : String!, currencyId : String!,paymentPreference : PaymentPreference, pictureUrl : String = "", callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, payerCost : PayerCost?) -> Void) -> UINavigationController {
        
        let paymentVault = PaymentVaultViewController(amount: amount, purchaseTitle : purchaseTitle, currencyId : currencyId, pictureUrl : pictureUrl, paymentPreference : paymentPreference, callback: callback)

        paymentVault.callback = {(paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, payerCost : PayerCost?) -> Void in
            paymentVault.dismissViewControllerAnimated(true, completion: { () -> Void in
                callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost: payerCost)
            })
        }
        
        paymentVault.modalTransitionStyle = .CrossDissolve
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }
    
    internal class func startPaymentVaultInCheckout(amount: Double, purchaseTitle : String!, currencyId : String!, pictureUrl : String, paymentSettings: PaymentPreference?, paymentMethodSearch : PaymentMethodSearch, callback: (paymentMethod: PaymentMethod, token: Token?, issuer: Issuer?, payerCost : PayerCost?) -> Void) -> UINavigationController {
        
        let paymentVault = PaymentVaultViewController(amount: amount, purchaseTitle : purchaseTitle, currencyId : currencyId, pictureUrl : pictureUrl, paymentSettings: paymentSettings, paymentMethodSearchItem: paymentMethodSearch.groups, paymentMethods: paymentMethodSearch.paymentMethods, tintColor: true, callback: callback)
        
        paymentVault.modalTransitionStyle = .CrossDissolve
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }

    
    
    public class func startCardFlow(paymentSettings: PaymentPreference? , amount: Double, callback: (paymentMethod: PaymentMethod, token: Token? ,  issuer: Issuer?, payerCost: PayerCost?) -> Void, var callbackCancel : (Void -> Void)? = nil) -> UINavigationController {
    
        var cardVC : UINavigationController?
        var ccf : CardFormViewController = CardFormViewController()
        
        if (callbackCancel == nil){
            callbackCancel = { cardVC?.dismissViewControllerAnimated(true, completion: { () -> Void in
            }) }
        }
        cardVC = MPStepBuilder.startCreditCardForm(paymentSettings, amount: amount, callback: { (paymentMethod, token, issuer) -> Void in
                MPFlowBuilder.getInstallments(token!, amount: amount, issuer: issuer!, paymentTypeId: PaymentTypeId.CREDIT_CARD, paymentMethod: paymentMethod, ccf: ccf, callback: { (paymentMethod, token, issuer, payerCost) in
                    callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost: payerCost)
                })
            
            }, callbackCancel : callbackCancel)
    
        ccf = cardVC?.viewControllers[0] as! CardFormViewController
    
        cardVC!.modalTransitionStyle = .CrossDissolve
        return cardVC!

    }
    
    internal class func getInstallments(token : Token, amount : Double, issuer: Issuer, paymentTypeId : PaymentTypeId, paymentMethod : PaymentMethod, ccf : MercadoPagoUIViewController, callback : (paymentMethod: PaymentMethod, token: Token? ,  issuer: Issuer?, payerCost: PayerCost?) -> Void){
        
        MPServicesBuilder.getInstallments(token.firstSixDigit, amount: amount, issuer: issuer, paymentTypeId: paymentTypeId, success: { (installments) -> Void in
            
            let pcvc = MPStepBuilder.startPayerCostForm(paymentMethod, issuer: issuer, token: token, amount:amount, minInstallments: nil, callback: { (payerCost) -> Void in
                callback(paymentMethod: paymentMethod, token: token, issuer: issuer, payerCost: payerCost)
            })
            
            ccf.navigationController!.pushViewController(pcvc, animated: false)
            
            }, failure: { (error) -> Void in
                let errorVC = MPStepBuilder.startErrorViewController(MPError.convertFrom(error), callback: { (Void) in
                    ccf.navigationController!.popViewControllerAnimated(true)
                    self.getInstallments(token, amount: amount, issuer: issuer, paymentTypeId: paymentTypeId, paymentMethod: paymentMethod, ccf: ccf, callback: callback)
                })
                ccf.navigationController!.pushViewController(errorVC, animated: true)
        })
    }

}
