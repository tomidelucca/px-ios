//
//  PaymentSettings.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 4/22/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation

public class PaymentSettings: NSObject {

    var maxAcceptedInstalment : Int?
    var defaultInstalment : Int?
    var defaultPaymentTypeId : PaymentTypeId?
    var defaultPaymentMethodId    : String?
    var excludedPaymentMethodsIds : Set<String>?
    var excludedPaymentTypesIds : Set<PaymentTypeId>?
    
    var currencyId : String!
    var purchaseTitle : String!
    
    public init (maxAcceptedInstalment : Int? = nil,
         defaultPaymentTypeId : PaymentTypeId? = nil,
         defaultInstalment : Int? = nil,
         defaultPaymentMethodId : String? = nil,
         excludedPaymentMethodsIds : Set<String>? = nil,
        excludedPaymentTypesIds : Set<PaymentTypeId>?  = nil,
        currencyId : String!   = nil,
        purchaseTitle : String?  = nil) {
        
            self.maxAcceptedInstalment = maxAcceptedInstalment
            self.defaultInstalment = defaultInstalment
            self.defaultPaymentTypeId = defaultPaymentTypeId
            self.defaultPaymentMethodId = defaultPaymentMethodId
            self.excludedPaymentMethodsIds = excludedPaymentMethodsIds
            self.excludedPaymentTypesIds = excludedPaymentTypesIds
            self.currencyId = currencyId
            self.purchaseTitle = purchaseTitle
    }
    
    
    public init (preferencePaymentMethods: PreferencePaymentMethods){
        
        maxAcceptedInstalment = preferencePaymentMethods.maxAcceptedInstalment
        defaultInstalment = preferencePaymentMethods.defaultInstallments
        defaultPaymentMethodId = preferencePaymentMethods.defaultPaymentMethodId
        excludedPaymentMethodsIds = preferencePaymentMethods.excludedPaymentMethodsIds
        excludedPaymentTypesIds = preferencePaymentMethods.excludedPaymentTypesIds
    }
    public func addSettings (        defaultPaymentTypeId : PaymentTypeId? = nil,
        defaultInstalment : Int? = nil,
        defaultPaymentMethodId : String? = nil,
        excludedPaymentMethodsIds : Set<String>? = nil,
        excludedPaymentTypesIds : Set<PaymentTypeId>?  = nil,
        currencyId : String!   = nil,
        purchaseTitle : String!  = nil, maxAcceptedInstalment : Int? = nil) -> PaymentSettings{
            
            if(maxAcceptedInstalment != nil){
               self.maxAcceptedInstalment = maxAcceptedInstalment
            }
            if(defaultInstalment != nil){
                self.defaultInstalment = defaultInstalment
            }
            if(defaultPaymentTypeId != nil){
                self.defaultPaymentTypeId = defaultPaymentTypeId
            }
            if(defaultPaymentMethodId != nil){
               self.defaultPaymentMethodId = defaultPaymentMethodId
            }
            if (excludedPaymentMethodsIds != nil){
               self.excludedPaymentMethodsIds = excludedPaymentMethodsIds
            }
            if (excludedPaymentTypesIds != nil){
                self.excludedPaymentTypesIds = excludedPaymentTypesIds
            }
            if (currencyId != nil){
                self.currencyId = currencyId
            }
            if (purchaseTitle != nil){
                self.purchaseTitle = purchaseTitle
            }
            
            
            return self
    }
}
