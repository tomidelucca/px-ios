//
//  Payer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Payer : Equatable {
    public var email : String!
    public var _id : NSNumber = 0
    public var identification : Identification!
    public var type : String!
    
    public init(_id : NSNumber? = 0, email: String? = nil, type : String? = nil, identification: Identification? = nil){
        self._id = _id!
        self.email = email
        self.type = type
        self.identification = identification
    }
    
    public class func fromJSON(json : NSDictionary) -> Payer {
        let payer : Payer = Payer()
        if json["id"] != nil && !(json["id"]! is NSNull) {
            payer._id = NSNumber(longLong: (json["id"] as? NSString)!.longLongValue)
        }
        payer.email = JSON(json["email"]!).asString
        payer.type = JSON(json["type"]!).asString
        if let identificationDic = json["identification"] as? NSDictionary {
            payer.identification = Identification.fromJSON(identificationDic)
        }
        return payer
    }
}


public func ==(obj1: Payer, obj2: Payer) -> Bool {
    
    let areEqual =
    obj1._id == obj2._id &&
    obj1.email == obj2.email &&
    obj1.identification == obj2.identification &&
    obj1.type == obj2.type
    
    return areEqual
}

