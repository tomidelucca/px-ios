//
//  MPXTracker.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 6/1/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

protocol MPXTracker {
    static var mpxPublicKey: String {get}
    static var mpxCheckoutVersion: String {get}
    static var mpxPlatform: String {get}
}

extension MPXTracker {
    
    
    
    static func trackScreen(screenId: String, screenName: String) {
        let clientId = UIDevice.current.identifierForVendor!.uuidString
        let applicationJSON = MPTApplication(publicKey: mpxPublicKey, checkoutVersion: mpxCheckoutVersion, platform: mpxPlatform).toJSON()
        let deviceJSON = MPTDevice().toJSON()
        let screenJSON = Self.screenJSON(screenId: screenId, screenName: screenName)
        let obj: [String:Any] = [
            "client_id": clientId,
            "application": applicationJSON,
            "device": deviceJSON,
            "events": [screenJSON]
        ] 
        let stringScreenTrack = JSONHandler.jsonCoding(obj)
        print("TRACK = \(stringScreenTrack)")
        
        self.request(url: "https://apis.mercadopago.com/beta/checkout/tracking/events", params: nil, body: JSONHandler.jsonCoding(obj), method: "POST", headers: nil, success: { (result) -> Void in
            print(result)
        }) { (error) -> Void in
            print(error)
        }
        
    }
    
    static func trackEvent(screenId: String, screenName: String, action: String, category: String, label:String, value:String) {
        let clientId = UIDevice.current.identifierForVendor!.uuidString
        let deviceJSON = MPTDevice().toJSON()
        let applicationJSON = MPTApplication(publicKey: mpxPublicKey, checkoutVersion: mpxCheckoutVersion, platform: mpxPlatform).toJSON()
         let eventJSON = Self.eventJSON(screenId: screenId, screenName: screenName, action: action, category: category, label: label, value: value)
        let obj: [String:Any] = [
            "client_id": clientId,
            "application": applicationJSON,
            "device": deviceJSON,
            "events":[eventJSON]
        ]
        let stringEventTrack = JSONHandler.jsonCoding(obj)
        print("TRACK = \(stringEventTrack)")
        self.request(url: "https://apis.mercadopago.com/beta/checkout/tracking/events", params: nil, body: JSONHandler.jsonCoding(obj), method: "POST", headers: nil, success: { (result) -> Void in
            print(result)
        }) { (error) -> Void in
            print(error)
        }
    }
    
    
    static func eventJSON(screenId: String, screenName: String, action: String, category: String, label:String, value:String) -> [String:Any]{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let timestamp = formatter.string(from: date)
        let obj: [String:Any] = [
            "timestamp": timestamp,
            "type": "action",
            "screen_id": screenId,
            "screen_name": screenName,
            "action": action,
            "category": category,
            "label": label,
            "value": value
        ]
        return obj
    }
 
    static func screenJSON(screenId: String, screenName: String) -> [String:Any]{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let timestamp = formatter.string(from: date)
        let obj: [String:Any] = [
            "timestamp": timestamp,
            "type": "screenview",
            "screen_id": screenId,
            "screen_name": screenName
        ]
        return obj
    }
    
    
    static func request(url: String, params: String?, body: Any, method: String, headers: NSDictionary? = nil, success: @escaping (Any) -> Void,
                              failure: ((NSError) -> Void)?) {
        
        var requesturl = url
        if params != nil {
            requesturl += "?" + params!
        }
        
        let finalURL: NSURL = NSURL(string: url)!
        let request: NSMutableURLRequest
        
        request = NSMutableURLRequest(url: finalURL as URL)
        
        request.url = finalURL as URL
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if headers !=  nil && headers!.count > 0 {
            for header in headers! {
                request.setValue(header.value as? String, forHTTPHeaderField: header.key as! String)
            }
        }
        
        if body != nil {
            request.httpBody = (body as! NSString).data(using: String.Encoding.utf8.rawValue)
        }
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (response: URLResponse?, data: Data?, error: Error?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                do {
                    let responseJson = try JSONSerialization.jsonObject(with: data!,
                                                                        options:JSONSerialization.ReadingOptions.allowFragments)
                    success(responseJson as Any)
                } catch {
                    
                    let e: NSError = NSError(domain: "com.mercadopago.sdk", code: NSURLErrorCannotDecodeContentData, userInfo: nil)
                    failure!(e)
                }
            } else {
                let response = String(describing: error)
                
                if failure != nil {
                    failure!(error! as NSError)
                }
            }
        }
    }
    
    
}
