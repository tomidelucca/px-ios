//
//  Issuer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Issuer : NSObject {
    public var _id : NSNumber?
    public var name : String?
    
    public class func fromJSON(json : NSDictionary) -> Issuer {
        let issuer : Issuer = Issuer()
        
        if let _id = JSONHandler.attemptParseToString(json["id"])?.numberValue{
            issuer._id = _id
        }
        if let name = JSONHandler.attemptParseToString(json["name"]){
            issuer.name = name
        }
        
        return issuer
    }
    
    public func toJSONString() -> String {
       return JSONHandler.jsonCoding(toJSON())
    }
    
    public func toJSON() -> [String:Any] {
        let obj:[String:Any] = [
            "id": self._id != nil ? JSONHandler.null : self._id!,
            "name" : self.name == nil ? JSONHandler.null : self.name!,
            ]
        return obj
    }
}

public func ==(obj1: Issuer, obj2: Issuer) -> Bool {
    
    let areEqual =
        obj1._id == obj2._id &&
        obj1.name == obj2.name
    
    return areEqual
}
