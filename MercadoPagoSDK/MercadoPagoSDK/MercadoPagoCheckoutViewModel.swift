//
//  CheckoutViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/23/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public enum CheckoutStep : String {
    case SEARCH_PAYMENT_METHODS = "search_payment_methods"
    case PAYMENT_METHOD = "payment_method"
    case PM_OFF = "payment_method_off"
    case CARD_FORM = "cardform"
    case CREDIT_DEBIT = "rejected"
    case ISSUER = "recovery"
    case IDENTIFICATION = "in_process"
}



open class MercadoPagoCheckoutViewModel: NSObject {

    let amount : Double = 1000
    var paymentMethods : [PaymentMethod]?
    var cardToken: CardToken?
    var payerCost: PayerCost?
    
    public func cardFormManager() -> CardViewModelManager{
        return CardViewModelManager(amount : amount, paymentMethods :nil, paymentSettings : nil)
    }
    public func payerCostViewModel() -> CardAdditionalStepViewModel{
        var pms : [PaymentMethod] = []
        if let _ = paymentMethods {
            pms = paymentMethods!
        }
        return CardAdditionalStepViewModel(paymentMethods: pms, issuer: nil, token: nil, amount: nil, paymentPreference: nil, installment: nil, callback: nil)
    }
    
    public func updateCheckoutModel(paymentMethods: [PaymentMethod], cardToken: CardToken?){
        self.paymentMethods = paymentMethods
        self.cardToken = cardToken
      
    }
    
    public func updateCheckoutModel(payerCost: PayerCost?){
        self.payerCost = payerCost
    }
    
    public func nextStep() -> CheckoutStep{
        
        return CheckoutStep.SEARCH_PAYMENT_METHODS
    }
    
   
    
}

