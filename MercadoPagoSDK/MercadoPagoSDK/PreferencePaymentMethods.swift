//
//  PreferencePaymentMethods.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PreferencePaymentMethods: Equatable {
    var excludedPaymentMethods : [String]?
    var excludedPaymentTypes : Set<PaymentTypeId>?
    var defaultPaymentMethodId : String?
    var installments : Int?
    var defaultInstallments : Int?

    public init(excludedPaymentMethods : [String]? = nil, excludedPaymentTypes: Set<PaymentTypeId>? = nil, defaultPaymentMethodId: String? = nil, installments : Int? = 0, defaultInstallments : Int? = 0){
        self.excludedPaymentMethods =  excludedPaymentMethods
        self.excludedPaymentTypes = excludedPaymentTypes
        self.defaultPaymentMethodId = defaultPaymentMethodId
        self.installments = installments
        self.defaultInstallments = defaultInstallments
    }
    
    public class func fromJSON(json : NSDictionary) -> PreferencePaymentMethods {
        let preferencePaymentMethods = PreferencePaymentMethods()
        
        var excludedPaymentMethods = [PaymentMethod]()
        if let pmArray = json["excluded_payment_methods"] as? NSArray {
            for i in 0..<pmArray.count {
                if let pmDic = pmArray[i] as? NSDictionary {
                    excludedPaymentMethods.append(PaymentMethod.fromJSON(pmDic))
                }
            }
        }
        
        var excludedPaymentTypes = [PaymentType]()
        if let ptArray = json["excluded_payment_types"] as? NSArray {
            for i in 0..<ptArray.count {
                if let ptDic = ptArray[i] as? NSDictionary {
                    excludedPaymentTypes.append(PaymentType.fromJSON(ptDic))
                }
            }
        }
        
        if json["default_payment_method_id"] != nil && !(json["default_payment_method_id"]! is NSNull) {
            preferencePaymentMethods.defaultPaymentMethodId = JSON(json["default_payment_method_id"]!).asString
        }
        
        if json["installments"] != nil && !(json["installments"]! is NSNull) {
            preferencePaymentMethods.installments = JSON(json["installments"]!).asInt
        }
        
        if json["default_installments"] != nil && !(json["default_installments"]! is NSNull) {
            preferencePaymentMethods.installments = JSON(json["default_installments"]!).asInt
        }
        
        return preferencePaymentMethods
    }
}

public func ==(obj1: PreferencePaymentMethods, obj2: PreferencePaymentMethods) -> Bool {
    
    let areEqual =
    obj1.excludedPaymentMethods == obj2.excludedPaymentMethods &&
    obj1.excludedPaymentTypes == obj2.excludedPaymentTypes &&
    obj1.defaultPaymentMethodId == obj2.defaultPaymentMethodId &&
    obj1.installments == obj2.installments &&
    obj1.defaultInstallments == obj2.defaultInstallments
    
    return areEqual
}


