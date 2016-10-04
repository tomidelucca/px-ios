//
//  InstructionsInfo.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 29/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class InstructionsInfo: NSObject {
    
    var amountInfo : AmountInfo!
    var instructions : [Instruction]!
    
    
    public class func fromJSON(json : NSDictionary) -> InstructionsInfo {
        
        let instructionsInfo : InstructionsInfo = InstructionsInfo()
        
        if json["amount_info"] != nil && !(json["amount_info"]! is NSNull) {
            instructionsInfo.amountInfo = AmountInfo.fromJSON(json["amount_info"] as! NSDictionary)
        }
       
        if json["instructions"] != nil && !(json["instructions"]! is NSNull) {
        
            var instructions = [Instruction]()
            let jsonResultArr = json["instructions"] as! NSArray
            for instuctionJson in jsonResultArr {
                instructions.append(Instruction.fromJSON(instuctionJson as! NSDictionary))
            }
            instructionsInfo.instructions = instructions
        }
        
        return instructionsInfo
    }
    
    public func toJSONString() -> String {
        var obj:[String:AnyObject] = [
            "amount_info": self.amountInfo.toJSON()
        ]
    
        if self.instructions != nil && self.instructions.count > 0 {
            let instructionsStringArr = self.instructions.map({$0.toJSON()})
            obj["instructions"] = NSArray(array :instructionsStringArr)
            
        }
            
        return JSONHandler.jsonCoding(obj)
    }

}
