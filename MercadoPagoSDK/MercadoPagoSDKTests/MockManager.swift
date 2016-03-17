//
//  MockManager.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 3/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation

class MockManager: NSObject {

    internal class func getMockFor(name : String) -> NSDictionary? {
        let path = NSBundle(forClass:MockManager.self).pathForResource("MockedData", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)
        do {
            let mockObj = try MockManager.convertStringToDictionary(dictPM?.valueForKey(name) as! String)!
            return mockObj
        } catch {
            print("Hubo un error")
        }
        return nil
    }

    internal class func getMockResponseFor(uri : String, method: String) throws -> NSDictionary?{
        let path = NSBundle(forClass:MockManager.self).pathForResource("MockedResponse", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)
        do {
            let mockObj = try MockManager.convertStringToDictionary(dictPM?.valueForKey(method + uri) as! String)
            return mockObj
        } catch {
            let mockArr = try MockManager.convertArrayToDictionary(dictPM?.valueForKey(method + uri) as! String)
            return mockArr
        }
    }
    
    internal class func convertStringToDictionary(text: String) throws -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
            return json
        }
        return nil
    }

    internal class func convertArrayToDictionary(text: String) throws -> NSDictionary? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            let jsonArr = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
            return jsonArr
        }
        return nil
    }



}
