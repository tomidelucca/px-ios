//
//  PreferencePaymentMethods.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentPreference: Equatable {
    
    public var excludedPaymentMethodIds : Set<String>?
    public var excludedPaymentTypeIds : Set<PaymentTypeId>?
    var defaultPaymentMethodId : String?
    var maxAcceptedInstallments : Int?
    var defaultInstallments : Int?
    var defaultPaymentTypeId : PaymentTypeId?

    //installments = sea mayor a cero y que el defaults_istallment sea mayor a 0
    // excluded_payment_method < payment_methods
    //excluded_payment_types < payment_types
    
    public func validate() -> Bool{
        if (maxAcceptedInstallments <= 0){
            return false
        }
        if (PaymentType.allPaymentIDs.count <= excludedPaymentTypeIds?.count){
            return false
        }

        return true
    }
    

    
    public init(excludedPaymentMethodsIds : Set<String>? = nil, excludedPaymentTypesIds: Set<PaymentTypeId>? = nil, defaultPaymentMethodId: String? = nil, maxAcceptedInstalment : Int? = 0, defaultInstallments : Int? = 0){
        self.excludedPaymentMethodIds =  excludedPaymentMethodsIds
        self.excludedPaymentTypeIds = excludedPaymentTypesIds
        self.defaultPaymentMethodId = defaultPaymentMethodId
        self.maxAcceptedInstallments = maxAcceptedInstalment
        self.defaultInstallments = defaultInstallments
    }
    
    public class func fromJSON(json : NSDictionary) -> PaymentPreference {
        let preferencePaymentMethods = PaymentPreference()
        
        var excludedPaymentMethods = Set<String>()
        if let pmArray = json["excluded_payment_methods"] as? NSArray {
            for i in 0..<pmArray.count {
                if let pmDic = pmArray[i] as? String {
                    excludedPaymentMethods.insert(pmDic)
                }
            }
            preferencePaymentMethods.excludedPaymentMethodIds = excludedPaymentMethods
        }
        
        var excludedPaymentTypesIds = Set<PaymentTypeId>()
        if let ptArray = json["excluded_payment_types"] as? NSArray {
            for i in 0..<ptArray.count {
                if let ptDic = ptArray[i] as? String {
                    excludedPaymentTypesIds.insert(PaymentTypeId(rawValue: ptDic)!)
                }
            }
            preferencePaymentMethods.excludedPaymentTypeIds = Set<PaymentTypeId>(excludedPaymentTypesIds)
        }
        
        if json["default_payment_method_id"] != nil && !(json["default_payment_method_id"]! is NSNull) {
            preferencePaymentMethods.defaultPaymentMethodId = JSON(json["default_payment_method_id"]!).asString
        }
        
        if json["installments"] != nil && !(json["installments"]! is NSNull) {
            preferencePaymentMethods.maxAcceptedInstallments = JSON(json["installments"]!).asInt
        }
        
        if json["default_installments"] != nil && !(json["default_installments"]! is NSNull) {
            preferencePaymentMethods.maxAcceptedInstallments = JSON(json["default_installments"]!).asInt
        }
        
        return preferencePaymentMethods
    }
}

public func ==(obj1: PaymentPreference, obj2: PaymentPreference) -> Bool {
    
    let areEqual =
    obj1.excludedPaymentMethodIds! == obj2.excludedPaymentMethodIds! &&
    obj1.excludedPaymentTypeIds == obj2.excludedPaymentTypeIds &&
    obj1.defaultPaymentMethodId == obj2.defaultPaymentMethodId &&
    obj1.maxAcceptedInstallments == obj2.maxAcceptedInstallments &&
    obj1.defaultInstallments == obj2.defaultInstallments
    
    return areEqual
}


