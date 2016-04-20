//
//  PaymentMethodsSearch.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//
import Foundation

public class PaymentMethodSearch: Equatable {
    
    var groups : [PaymentMethodSearchItem]!
    var paymentMethods : [PaymentMethod]!
    

    public class func fromJSON(json : NSDictionary) -> PaymentMethodSearch {
        let pmSearch = PaymentMethodSearch()
        
        var groups = [PaymentMethodSearchItem]()
        if let groupsJson = json["groups"] as? NSArray {
            for i in 0..<groupsJson.count {
                if let groupDic = groupsJson[i] as? NSDictionary {
                    groups.append(PaymentMethodSearchItem.fromJSON(groupDic))
                }
            }
            pmSearch.groups = groups
        }
        
        var paymentMethods = [PaymentMethod]()
        if let paymentMethodsJson = json["payment_methods"] as? NSArray {
            for i in 0..<paymentMethodsJson.count {
                if let paymentMethodsDic = paymentMethodsJson[i] as? NSDictionary {
                    paymentMethods.append(PaymentMethod.fromJSON(paymentMethodsDic))
                }
            }
            pmSearch.paymentMethods = paymentMethods
        }

        return pmSearch
    }
    
}

public func ==(obj1: PaymentMethodSearch, obj2: PaymentMethodSearch) -> Bool {
    let areEqual =
    obj1.groups == obj2.groups &&
    obj1.paymentMethods == obj2.paymentMethods
    return areEqual
}