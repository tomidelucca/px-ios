//
//  MockManager.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 3/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation

class MockManager: NSObject {

    public class func getMockFor(name : String) -> NSDictionary?{
        let path = NSBundle(forClass:MockManager.self).pathForResource("MockedData", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)
        let mockObj = MockManager.convertStringToDictionary(dictPM?.valueForKey(name) as! String)
        return mockObj
    }

    
    public class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    
}
