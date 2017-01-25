//
//  NSDictionary+Additions.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 1/25/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    public func toJsonString() -> String{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                return jsonString
            }
            return ""
            
        } catch {
            return error.localizedDescription
        }
    }
    
    func parseToLiteral() -> [String:Any] {
        
        var anyDict = [String: Any]()
        
        for (key, value) in self {
            anyDict[key as! String] = value
        }
        return anyDict
    }

}
