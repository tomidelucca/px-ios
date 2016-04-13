//
//  MockBuilder.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation

class MockBuilder: NSObject {
    
    internal class var MOCK_PAYMENT_ID : Int {
        return 1826290155
    }
    
    internal class var MOCK_PUBLIC_KEY : String {
        return "TEST-5999d034-afe5-4005-b22f-dccb5b576d55"
    }
    
    class var PREF_ID_MOCK : String {
        return "167833503-bbb3c69e-d91e-4328-9f50-169a06ebc749"
    }
    
    class func buildCheckoutPreference() -> CheckoutPreference {
        let preference = CheckoutPreference()
        preference._id = PREF_ID_MOCK
        preference.items = [self.buildItem("itemId", quantity: 1, unitPrice: 10), self.buildItem("itemId2", quantity: 2, unitPrice: 10)]
        preference.payer = Payer.fromJSON(MockManager.getMockFor("Payer")!)
        return preference
    }
    
    class func buildItem(id : String, quantity : Int, unitPrice : Double) -> Item {
        return Item(_id: id, title : "item title", quantity: quantity, unitPrice: unitPrice)
    }
    
    class func buildPayer(id : NSNumber, type : String) -> Payer {
        let payer =  Payer()
        payer._id = id
        payer.type = type
        return payer
    }
    
    class func buildPreferencePaymentMethods() -> PreferencePaymentMethods {
        let preferencePM = PreferencePaymentMethods()
        preferencePM.defaultInstallments = 1
        preferencePM.defaultPaymentMethodId = "visa"
        preferencePM.excludedPaymentMethods = ["amex"]
        preferencePM.excludedPaymentTypes = self.getMockPaymentTypeIds()
        return preferencePM
    }
    
    
    class func buildPaymentMethod(id : String) -> PaymentMethod {
        let paymentMethod = PaymentMethod.fromJSON(MockManager.getMockFor("PaymentMethod")!)
        paymentMethod._id = id
        return paymentMethod
    }
    
    class func buildSecurityCode() -> SecurityCode {
        let securityCode = SecurityCode()
        securityCode.length = 3
        securityCode.mode = "mode"
        securityCode.cardLocation = "back"
        return securityCode
    }
    
    class func buildIdentification() -> Identification {
        let identification = Identification()
        identification.type = "type"
        identification.number = "number"
        return identification
    }
    
    class func buildCard() -> Card {
        let card = Card()
        card.idCard = 1234567890
        return card
    }
    
    class func buildPayment(paymentMethodId : String) -> Payment {
        let payment = Payment()
        payment._id = self.MOCK_PAYMENT_ID
        payment.paymentMethodId = paymentMethodId
        return payment
    }
    
    
    class func buildPaymentMethodSearchItem(paymentMethodId : String, type : PaymentMethodSearchItemType? = nil) -> PaymentMethodSearchItem{
        let paymentMethodSearchItem = PaymentMethodSearchItem()
        paymentMethodSearchItem.idPaymentMethodSearchItem = paymentMethodId
        if type != nil {
            paymentMethodSearchItem.type = type
        }
        return paymentMethodSearchItem
    }
    
    class func getMockPaymentMethods() -> [PaymentMethod] {
        return [self.buildPaymentMethod("amex"), self.buildPaymentMethod("oxxo")]
    }
    
    
    class func getMockPaymentTypeIds() -> Set<PaymentTypeId>{
        return Set([PaymentTypeId.BITCOIN, PaymentTypeId.ACCOUNT_MONEY])
    }
    
    class func buildPaymentType() -> PaymentType{
        let creditCardPaymentTypeId = PaymentTypeId.CREDIT_CARD
        return PaymentType(paymentTypeId: creditCardPaymentTypeId)
    }
}
