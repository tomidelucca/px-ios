//
//  CheckoutPreference.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CheckoutPreference : NSObject {

    public var id : String!
    public var items : [Item]?
    public var payer : Payer?
    public var paymentMethods : PreferencePaymentMethods?
    //shipments
    
    public override init(){
        super.init()
    }
    
    public class func fromJSON(json : NSDictionary) -> CheckoutPreference {
        let preference : CheckoutPreference = CheckoutPreference()

        if json["id"] != nil && !(json["id"]! is NSNull) {
            preference.id = (json["id"]! as? String)
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
        let obj:[String:AnyObject] = [
            "items": (self.items != nil && self.items!.count > 0) ? self.items! : JSON.null
        ]
        return JSON(obj).toString()
    }
    
    public func getAmount() -> Double {
        var amount = 0.0
        for item in self.items! {
            amount = amount + (Double(item.quantity) * item.unitPrice)
        }
        return amount
    }
    
    public func getPaymentTypeIdsSupported() -> Set<PaymentTypeId> {
        let ptIds = PaymentType.allPaymentIDs.subtract(paymentMethods!.excludedPaymentTypes!)
        return ptIds
    }
 
}