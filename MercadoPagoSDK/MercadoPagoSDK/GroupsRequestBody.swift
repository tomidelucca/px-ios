//
//  GroupsRequestBody.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 11/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class GroupsRequestBody: NSObject {
    
    var amount : Double!
    var paymentPreference = PaymentPreference()
    let payer = Payer()
    
    init(amount : Double, excludedPaymentMethodsIds : Set<String>? = nil, excludedPaymentTypesIds: Set<String>? = nil, payerEmail : String? = nil, payerAccessToken : String? = nil){
        super.init()
        self.amount = amount
        self.paymentPreference.excludedPaymentTypeIds = excludedPaymentTypesIds
        self.paymentPreference.excludedPaymentMethodIds = excludedPaymentMethodsIds
        self.payer.email = payerEmail
        self.payer.accessToken = payerAccessToken
    }
    
    open func toJSON() -> [String:Any] {
        var obj:[String:Any] = [
            "amount": self.amount,
            "payer" : self.payer.toJSON()
        ]
        
        
        if let excludedPaymentMethodIds = self.paymentPreference.excludedPaymentMethodIds {
            if excludedPaymentMethodIds.count > 0 {
                obj["excluded_payment_methods"] = Array(excludedPaymentMethodIds)
            }
        }
        
        if let excludedPaymentTypeIds = self.paymentPreference.excludedPaymentTypeIds {
            if excludedPaymentTypeIds.count > 0 {
                obj["excluded_payment_types"] = Array(excludedPaymentTypeIds)
            }
        }
         
        return obj
    }
    
    
    open func toJSONString() -> String {
        return JSONHandler.jsonCoding(self.toJSON())
    }

}
