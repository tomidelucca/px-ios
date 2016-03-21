//
//  CheckoutPreference.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CheckoutPreference : Equatable {
    
    public var _id : String!
    public var items : [Item]? // que el conjunto no sea nulo y que no este vacio, que todos los items tengan la misma currency
                               // que cada item no sea nulo, que su cantidad sea 1 o mayor
                                // que el precio no sea nulo, ni menor o igual a cero
                                // currency no nula
                                // sean monedas conocidas (argentina, brasil, chile, colombia, mexico, venezuela y eeuu)
    public var payer : Payer?
    public var paymentMethods : PreferencePaymentMethods? //installments = sea mayor a cero y que el defaults_istallment sea mayor a 0
                                                        // excluded_payment_method < payment_methods
                                                        //excluded_payment_types < payment_types
    
    
    
    
    
    //shipments
    
    //DATE ACTIVE = expiration_date_from
    //DATE EXPIRATION = expiration_date_to
    // que el dia actual caiga en ese rango (de activacion) OJO!!! PUEDEN SER NULAS LAS FECHAS, en ese caso, no mueren nunca, y siempre es valida la preference
    
    public func validate() -> Bool{
    
        if(items == nil){
            return false
        }
        if(items?.count == 0){
            return false
        }
        //VALIDAR CADA ITEM
        //VALIDAR PREFERENCE PAYMENT METHOD
        return true
    }
    
    public init(items : [Item] = [], payer : Payer? = nil, paymentMethods : PreferencePaymentMethods? = nil){
        self.items = items
        self.payer = payer
        self.paymentMethods = paymentMethods
    }
    
    
    public class func fromJSON(json : NSDictionary) -> CheckoutPreference {
        let preference : CheckoutPreference = CheckoutPreference()
        
        if json["id"] != nil && !(json["id"]! is NSNull) {
            preference._id = (json["id"]! as? String)
        }
        
        if json["payer"] != nil && !(json["payer"]! is NSNull) {
            preference.payer = Payer.fromJSON(json["payer"]! as! NSDictionary)
        }
        
        var items = [Item]()
        if let itemsArray = json["items"] as? NSArray {
            for i in 0..<itemsArray.count {
                if let itemDic = itemsArray[i] as? NSDictionary {
                    items.append(Item.fromJSON(itemDic))
                }
            }
            
            preference.items = items
        }
        
        return preference
    }
    
    public func toJSONString() -> String {
        //TODO
        return ""
    }
    
    public func getAmount() -> Double {
        var amount = 0.0
        for item in self.items! {
            amount = amount + (Double(item.quantity) * item.unitPrice)
        }
        return amount
    }
    
    public func getInstallments() -> Int {
        if self.paymentMethods != nil {
            if (self.paymentMethods!.installments != nil) {
                return self.paymentMethods!.installments!
            } else if (self.paymentMethods!.defaultInstallments != nil) {
                return self.paymentMethods!.defaultInstallments!
            }
        }
        return 1
    }
    
    public func getExcludedPaymentTypes() -> Set<PaymentTypeId>? {
        if (self.paymentMethods != nil && self.paymentMethods!.excludedPaymentTypes != nil) {
            return self.paymentMethods!.excludedPaymentTypes
        }
        return nil
    }
    
    public func getExcludedPaymentMethods() -> [String]? {
        if (self.paymentMethods != nil && self.paymentMethods!.excludedPaymentMethods != nil) {
            return self.paymentMethods!.excludedPaymentMethods
        }
        return nil
    }

    public func getDefaultPaymentMethodId() -> String? {
        if (self.paymentMethods != nil && self.paymentMethods!.defaultPaymentMethodId != nil && self.paymentMethods!.defaultPaymentMethodId!.isNotEmpty) {
            return self.paymentMethods!.defaultPaymentMethodId
        }
        return nil
    }
    
    internal class func wrapPrefenceWithSettings(amount : Double, title : String, currencyId : String, excludedPaymentMethods : [String]?, excludedPaymentTypes : Set<PaymentTypeId>?, defaultPaymentMethodId : String?, installmensts : Int?, defaultInstallments : Int?) -> CheckoutPreference {
        let item = Item()
        item.unitPrice = amount
        item.title = title
        item.currencyId = currencyId
        var items = [Item]()
        items.append(item)
        let preference = CheckoutPreference()
        preference.items = items
        preference.setPaymentMethods(excludedPaymentMethods, excludedPaymentTypes: excludedPaymentTypes, defaultPaymentMethodId: defaultPaymentMethodId, installmensts: installmensts, defaultInstallments: defaultInstallments)
        return preference
    }
    
    private func setPaymentMethods(excludedPaymentMethods : [String]?, excludedPaymentTypes : Set<PaymentTypeId>?, defaultPaymentMethodId : String?, installmensts : Int?, defaultInstallments : Int?) {
        self.paymentMethods = PreferencePaymentMethods(excludedPaymentMethods: excludedPaymentMethods, excludedPaymentTypes: excludedPaymentTypes, defaultPaymentMethodId: defaultPaymentMethodId, installments: installmensts, defaultInstallments: defaultInstallments)
        
    }
}

public func ==(obj1: CheckoutPreference, obj2: CheckoutPreference) -> Bool {
    
    let areEqual =
        obj1._id == obj2._id &&
        obj1.items! == obj2.items! &&
        obj1.payer == obj2.payer &&
        obj1.paymentMethods == obj2.paymentMethods
    
    return areEqual
}


