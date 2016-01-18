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
    
    
    internal class func getViewForPaymentMethodSelected(paymentMethodSearchItem : PaymentMethodSearchItem) -> UIViewController? {
        let paymentType = PaymentTypeId(rawValue: paymentMethodSearchItem.idPaymentMethodSearchItem)
        if paymentType!.isCard() {
            // new Card
            let ccPaymentMethod = PaymentMethod()
            ccPaymentMethod.paymentTypeId = paymentType
            return MPStepBuilder.startNewCardStep(ccPaymentMethod, callback: { (cardToken: CardToken) -> Void in
                //Congrats
            })
        } else if paymentType == PaymentTypeId.ATM || paymentType == PaymentTypeId.BANK_TRANFER {
            // off payment
        } else if paymentType == PaymentTypeId.DIGITAL_CURRENCY {
            //bitcoin
        } else if paymentType == PaymentTypeId.ACCOUNT_MONEY {
            //wallet
        }
        return nil

    }
}

