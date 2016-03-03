//
//  InstructionReference.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 18/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class InstructionReference: Equatable {

    var label : String!
    var value : [String]!
    var separator : String!
    
    public func getFullReferenceValue() -> String {
        if separator == nil  {
            self.separator = ""
        }
        let referenceFullValue : NSString = value.reduce("", combine: {($0 as String) + self.separator + $1})
        return referenceFullValue.substringFromIndex(self.separator.characters.count)
    }
    
    public class func fromJSON(json : NSDictionary) -> InstructionReference {
        let reference = InstructionReference()
        if json["label"] != nil && !(json["label"]! is NSNull) {
            reference.label = json["label"] as! String
        }
        
        if json["field_value"] != nil && !(json["field_value"]! is NSNull) {
            reference.value = [String]()
            let values = json["field_value"] as! NSArray
            for val in values {
                reference.value.append(String(val))
            }
            
        }
        
        if json["separator"] !=  nil && !(json["separator"]! is NSNull) {
            reference.separator = json["separator"] as! String
        }
        
        return reference
    }
}


public func ==(obj1: InstructionReference, obj2: InstructionReference) -> Bool {
    let areEqual =
    obj1.label == obj2.label &&
    obj1.value == obj2.value &&
    obj1.separator == obj2.separator
    
    return areEqual
}

