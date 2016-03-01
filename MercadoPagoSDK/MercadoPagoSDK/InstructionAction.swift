//
//  InstructionAction.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 18/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionAction: Equatable {
    
    var label: String
    var url : String
    var tag : String

    init(label : String, url : String, tag: String){
        self.label = label
        self.url = url
        self.tag = tag
    }
    
    /*public class func fromJSON(json : NSDictionary) -> Instruction {}
    
    
    "label":"Ir a banca en lÃ­nea",
    "url":"http://www.banamex.com.mx",
    "tag":"link"
    
    */
    
}
public func ==(obj1: InstructionAction, obj2: InstructionAction) -> Bool {
    let areEqual =
    obj1.label == obj2.label &&
        obj1.url == obj2.url &&
        obj1.tag == obj2.tag
    
    return areEqual
}
