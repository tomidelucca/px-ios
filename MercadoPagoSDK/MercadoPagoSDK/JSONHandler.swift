//
//  JSONHandler.swift
//  MPTracker
//
//  Created by Demian Tejo on 9/26/16.
//  Copyright © 2016 Demian Tejo. All rights reserved.
//

import UIKit

class JSONHandler: NSObject {

    /*
    class func jsonCoding(jsonDictionary: [String:Any]) -> Any {
        var result : Any = ""
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            result = decoded
        }catch{
            print("ERROR CONVERTING ARRAY TO JSON, ERROR = \(error)")
        }
        return result

    }
    
    class func parseToJSON(data:Data) -> Any{
        var result : Any = []
        do{
            result = try JSONSerialization.jsonObject(with: data, options: [])
        }catch{
            print("ERROR PARSIBNG JSON, ERROR = \(error)")
        }
        return result
    }
    */
    
    //For compiling porpouse
    class func jsonCoding(jsonDictionary: [String:AnyObject]) -> String {
        var result : String = ""
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDictionary as AnyObject, options: .PrettyPrinted)
            let decoded = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            result = decoded.description
        }catch{
            print("ERROR CONVERTING ARRAY TO JSON, ERROR = \(error)")
        }
        return result
        
    }
    
    class func parseToJSON(data:NSData) -> Any{
        var result : Any = []
        do{
            result = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        }catch{
            print("ERROR PARSIBNG JSON, ERROR = \(error)")
        }
        return result
    }

    
    class func attemptParseToString(anyobject: AnyObject?, defaultReturn: String? = nil) -> String?{

        guard let _ = anyobject , let string = anyobject!.description else {
            return defaultReturn
        }
        return string
    }
    
    class func attemptParseToBool(anyobject: AnyObject?) -> Bool?{
        if anyobject is Bool {
            return anyobject as! Bool?
        }
        guard let string = attemptParseToString(anyobject) else {
            return nil
        }
        return string.toBool()
    }
    
    class func attemptParseToDouble(anyobject: AnyObject? , defaultReturn: Double? = nil) -> Double?{
        
        guard let string = attemptParseToString(anyobject) else {
            return defaultReturn
        }
        return Double(string) ?? defaultReturn
    }
    class func attemptParseToInt(anyobject: AnyObject?, defaultReturn: Int? = nil) -> Int?{
        
        guard let string = attemptParseToString(anyobject) else {
            return defaultReturn
        }
        return Int(string) ?? defaultReturn
    }
    
    internal class var null:NSNull { return NSNull() }
 }

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "YES", "yes", "1":
            return true
        case "False", "false", "NO", "no", "0":
            return false
        default:
            return nil
        }
    }
}

extension String {
    
    var numberValue:NSNumber? {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter.numberFromString(self)
    }
}

