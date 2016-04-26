//
//  PreferencePaymentMethods.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PreferencePaymentMethods: Equatable {
    public var excludedPaymentMethodsIds : Set<String>?
    public var excludedPaymentTypesIds : Set<PaymentTypeId>?
    var defaultPaymentMethodId : String?
    var maxAcceptedInstalment : Int?
    var defaultInstallments : Int?

    //installments = sea mayor a cero y que el defaults_istallment sea mayor a 0
    // excluded_payment_method < payment_methods
    //excluded_payment_types < payment_types
    
    public func validate() -> Bool{
        if (maxAcceptedInstalment <= 0){
            return false
        }
        if (PaymentType.allPaymentIDs.count <= excludedPaymentTypesIds?.count){
            return false
        }

        return true
    }
    

    
    public init(excludedPaymentMethodsIds : Set<String>? = nil, excludedPaymentTypesIds: Set<PaymentTypeId>? = nil, defaultPaymentMethodId: String? = nil, maxAcceptedInstalment : Int? = 0, defaultInstallments : Int? = 0){
        self.excludedPaymentMethodsIds =  excludedPaymentMethodsIds
        self.excludedPaymentTypesIds = excludedPaymentTypesIds
        self.defaultPaymentMethodId = defaultPaymentMethodId
        self.maxAcceptedInstalment = maxAcceptedInstalment
        self.defaultInstallments = defaultInstallments
    }
    
    public class func fromJSON(json : NSDictionary) -> PreferencePaymentMethods {
        let preferencePaymentMethods = PreferencePaymentMethods()
        
        var excludedPaymentMethods = Set<String>()
        if let pmArray = json["excluded_payment_methods"] as? NSArray {
            for i in 0..<pmArray.count {
                if let pmDic = pmArray[i] as? String {
                    excludedPaymentMethods.insert(pmDic)
                }
            }
            preferencePaymentMethods.excludedPaymentMethodsIds = excludedPaymentMethods
        }
        
        var excludedPaymentTypesIds = Set<PaymentTypeId>()
        if let ptArray = json["excluded_payment_types"] as? NSArray {
            for i in 0..<ptArray.count {
                if let ptDic = ptArray[i] as? String {
                    excludedPaymentTypesIds.insert(PaymentTypeId(rawValue: ptDic)!)
                }
            }
            preferencePaymentMethods.excludedPaymentTypesIds = Set<PaymentTypeId>(excludedPaymentTypesIds)
        }
        
        if json["default_payment_method_id"] != nil && !(json["default_payment_method_id"]! is NSNull) {
            preferencePaymentMethods.defaultPaymentMethodId = JSON(json["default_payment_method_id"]!).asString
        }
        
        if json["installments"] != nil && !(json["installments"]! is NSNull) {
            preferencePaymentMethods.maxAcceptedInstalment = JSON(json["installments"]!).asInt
        }
        
        if json["default_installments"] != nil && !(json["default_installments"]! is NSNull) {
            preferencePaymentMethods.maxAcceptedInstalment = JSON(json["default_installments"]!).asInt
        }
        
        return preferencePaymentMethods
    }
}

public func ==(obj1: PreferencePaymentMethods, obj2: PreferencePaymentMethods) -> Bool {
    
    let areEqual =
    obj1.excludedPaymentMethodsIds! == obj2.excludedPaymentMethodsIds! &&
    obj1.excludedPaymentTypesIds == obj2.excludedPaymentTypesIds &&
    obj1.defaultPaymentMethodId == obj2.defaultPaymentMethodId &&
    obj1.maxAcceptedInstalment == obj2.maxAcceptedInstalment &&
    obj1.defaultInstallments == obj2.defaultInstallments
    
    return areEqual
}


