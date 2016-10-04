//
//  IdentificationType.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 2/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class IdentificationType : NSObject {
    public var _id : String?
    public var name : String?
    public var type : String?
    public var minLength : Int = 0
    public var maxLength : Int = 0
    
    
    
    public class func fromJSON(json : NSDictionary) -> IdentificationType {
        let identificationType : IdentificationType = IdentificationType()
        if let _id = JSONHandler.attemptParseToString(json["id"]){
            identificationType._id = _id
        }
        if let name = JSONHandler.attemptParseToString(json["name"]){
            identificationType.name = name
        }
        if let type = JSONHandler.attemptParseToString(json["typed"]){
            identificationType.type = type
        }
        if let minLength = JSONHandler.attemptParseToInt(json["min_length"]){
            identificationType.minLength = minLength
        }
        if let maxLength = JSONHandler.attemptParseToInt(json["max_length"]){
            identificationType.maxLength = maxLength
        }
        return identificationType
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "_id": self._id != nil ? JSON.null : self._id!,
            "name" : self.name == nil ? JSON.null : self.name!,
            "type" : self.type == nil ? JSON.null : self.type!,
            "min_length" : self.minLength,
            "max_length" : self.maxLength
        ]
        return JSONHandler.jsonCoding(obj)
    }
}

public func ==(obj1: IdentificationType, obj2: IdentificationType) -> Bool {
    
    let areEqual =
        obj1._id == obj2._id &&
        obj1.name == obj2.name &&
        obj1.type == obj2.type &&
        obj1.minLength == obj2.minLength &&
        obj1.maxLength == obj2.maxLength
    
    return areEqual
}
