//
//  MPStepBuilder.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

public class MPStepBuilder : NSObject {
    
    
    
    public class func startCustomerCardsStep(cards: [Card], callback: (selectedCard: Card?) -> Void) -> CustomerCardsViewController {
        return CustomerCardsViewController(cards: cards, callback: callback)
    }
    
    public class func startNewCardStep(paymentMethod: PaymentMethod, requireSecurityCode: Bool = true, callback: (cardToken: CardToken) -> Void) -> NewCardViewController {
        
        return NewCardViewController(paymentMethod: paymentMethod, requireSecurityCode: requireSecurityCode, callback: callback)
        
    }
    
    public class func startPaymentMethodsStep(supportedPaymentTypes: Set<PaymentTypeId>, callback:(paymentMethod: PaymentMethod) -> Void) -> PaymentMethodsViewController {
        
        return PaymentMethodsViewController(supportedPaymentTypes: supportedPaymentTypes, callback: callback)
    }
    
    public class func startIssuersStep(paymentMethod: PaymentMethod, callback: (issuer: Issuer) -> Void) -> IssuersViewController {
        return IssuersViewController(paymentMethod: paymentMethod, callback: callback)
    }
    
    public class func startInstallmentsStep(payerCosts: [PayerCost], amount: Double, callback: (payerCost: PayerCost?) -> Void) -> InstallmentsViewController {
        return InstallmentsViewController(payerCosts: payerCosts, amount: amount, callback: callback)
    }
    
    public class func startCongratsStep(payment: Payment, paymentMethod: PaymentMethod) -> CongratsViewController {
        return CongratsViewController(payment: payment, paymentMethod: paymentMethod)
    }
    
    public class func startPromosStep() -> PromoViewController {
        return PromoViewController()
    }
    
    
    internal class func getViewForPaymentMethodSelected(paymentMethodSearchItem : PaymentMethodSearchItem, callback: (UIViewController)-> Void)  {
        let paymentType = PaymentTypeId(rawValue: paymentMethodSearchItem.idPaymentMethodSearchItem)
        if paymentType!.isCard() {
            // new Card
            MPServicesBuilder.getPaymentMethods({ (var paymentMethods) -> Void in
                //TODO: uses first cc found
                paymentMethods = paymentMethods!.filter({$0.paymentTypeId == paymentType})
                callback(MPStepBuilder.startNewCardStep(paymentMethods![0], callback: { (cardToken: CardToken) -> Void in
                    //Congrats
                }))
                }, failure: { (error) -> Void in
                    //TODO
            })
        } else if paymentType == PaymentTypeId.ATM || paymentType == PaymentTypeId.BANK_TRANFER {
            // off payment
            callback(ConfirmOfflinePaymentViewController())
        } else if paymentType == PaymentTypeId.DIGITAL_CURRENCY {
            //bitcoin

        } else if paymentType == PaymentTypeId.ACCOUNT_MONEY {
            //wallet
    
        }
    }
}

