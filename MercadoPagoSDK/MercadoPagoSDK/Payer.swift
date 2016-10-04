//
//  Payer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Payer : NSObject {
    public var email : String!
    public var _id : NSNumber = 0
    public var identification : Identification!
    
    
    
    public init(_id : NSNumber? = 0, email: String? = nil, type : String? = nil, identification: Identification? = nil){
        self._id = _id!
        self.email = email
        self.identification = identification
    }
    
    public class func fromJSON(json : NSDictionary) -> Payer {
        let payer : Payer = Payer()
        if let _id = JSONHandler.attemptParseToString(json["id"])?.numberValue {
             payer._id  = _id
        }
        if let email = JSONHandler.attemptParseToString(json["email"]) {
            payer.email  = email
        }
        
        if let identificationDic = json["identification"] as? NSDictionary {
            payer.identification = Identification.fromJSON(identificationDic)
        }
        return payer
    }
    
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "email": self.email == nil ? JSON.null : (self.email!),
            "_id": self._id == 0 ? JSON.null : self._id,
            "identification" : self.identification == nil ? JSON.null : self.identification.toJSONString()
        ]
        return JSONHandler.jsonCoding(obj)
    }

}


public func ==(obj1: Payer, obj2: Payer) -> Bool {
    
    let areEqual =
    obj1._id == obj2._id &&
    obj1.email == obj2.email &&
    obj1.identification == obj2.identification
    
    return areEqual
}

