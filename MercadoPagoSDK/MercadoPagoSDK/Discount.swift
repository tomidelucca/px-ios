//
//  Discount.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Discount : Equatable {
    public var amountOff : NSNumber = 0
    public var couponAmount : NSNumber = 0
    public var currencyId : String!
    public var _id : Int = 0
    public var name : String!
    public var percentOff : NSNumber = 0
    
    
    
    public init (amountOff: NSNumber? = 0, couponAmount : NSNumber? = 0, currencyId: String? = nil, _id: Int? = 0, name : String? = nil, percentOff : NSNumber? = 0 ) {
        self.amountOff = amountOff!
        self.couponAmount = couponAmount!
        self.currencyId = currencyId
        self._id = _id!
        self.name = name
        self.percentOff = percentOff!
    }
    
    public class func fromJSON(json : NSDictionary) -> Discount {
        let discount : Discount = Discount()
		if json["amount_off"] != nil && !(json["amount_off"]! is NSNull) {
			discount.amountOff = NSNumber(longLong: (json["amount_off"] as? NSString)!.longLongValue)
		}
		if json["coupon_amount"] != nil && !(json["coupon_amount"]! is NSNull) {
			discount.couponAmount = NSNumber(longLong: (json["coupon_amount"] as? NSString)!.longLongValue)
		}
        discount.currencyId = JSON(json["currency_id"]!).asString
		if json["id"] != nil && !(json["id"]! is NSNull) {
			discount._id = (json["id"]! as? Int)!
		}
        discount.name = JSON(json["name"]!).asString
		if json["percent_off"] != nil && !(json["percent_off"]! is NSNull) {
			discount.percentOff = NSNumber(longLong: (json["percent_off"] as? NSString)!.longLongValue)
		}
        return discount
    }
    
    
}
public func ==(obj1: Discount, obj2: Discount) -> Bool {
    
    let areEqual =
    obj1.amountOff == obj2.amountOff &&
        obj1.couponAmount == obj2.couponAmount &&
        obj1.currencyId == obj2.currencyId &&
        obj1._id == obj2._id &&
        obj1.name == obj2.name &&
        obj1.percentOff == obj2.percentOff
    
    return areEqual
}
