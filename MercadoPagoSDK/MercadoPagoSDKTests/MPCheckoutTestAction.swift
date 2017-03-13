//
//  TestAction.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 3/13/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class MPCheckoutTestAction: NSObject {

    
    static func loadGroupsInViewModel(mpCheckout : MercadoPagoCheckout) {
        let accountMoneyOption = MockBuilder.buildCustomerPaymentMethod("account_money", paymentMethodId : "account_money")
        let customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PaymentMethodSearchItemType.PAYMENT_TYPE)
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")
        
        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups : [creditCardOption], paymentMethods : [paymentMethodVisa], customOptions : [customerCardOption, accountMoneyOption])
        mpCheckout.viewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)
    }
    
    static func selectAccountMoney(mpCheckout : MercadoPagoCheckout){
        let accountMoneyOption = MockBuilder.buildCustomerPaymentMethod("account_money", paymentMethodId : "account_money")
        mpCheckout.viewModel.paymentOptionSelected = accountMoneyOption as! PaymentMethodOption
    }
    
    static func selectCreditCardOption(mpCheckout : MercadoPagoCheckout){
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PaymentMethodSearchItemType.PAYMENT_TYPE)
        mpCheckout.viewModel.paymentOptionSelected = creditCardOption
    }
    
    
}
