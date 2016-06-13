//
//  TrackService.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 6/13/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class TrackService: NSObject {

    static let MP_TRACK_TOKEN_URL = "https://api.mercadopago.com/beta/checkout/tracking"
    static let MP_TRACK_PAYMENTOFF_URL = "https://api.mercadopago.com/beta/checkout/tracking/off"

    
    var baseURL : String!
    init (baseURL : String) {
        super.init()
        self.baseURL = baseURL
    }

    public class func trackToken(token: String!){
        
        let obj:[String:AnyObject] = ["public_key": MercadoPagoContext.publicKey() , "token":token!,"sdk_flavor":"3","sdk_platform":"iOS","sdk_type":"native","sdk_version":"1.0.1"]
            
        self.request(TrackService.MP_TRACK_TOKEN_URL, params: nil, body: JSON(obj).toString(), method: "POST", headers: nil, success: { (jsonResult) -> Void in
            
            }) { (error) -> Void in
                
        }
    }
    
    
    public class func trackPaymentOff(paymentID: String!){
        
        let obj:[String:AnyObject] = ["public_key": MercadoPagoContext.publicKey() , "token":paymentID!,"sdk_flavor":"3","sdk_platform":"iOS","sdk_type":"native","sdk_version":"1.0.1"]
        
        self.request(TrackService.MP_TRACK_TOKEN_URL, params: nil, body: JSON(obj).toString(), method: "POST", headers: nil, success: { (jsonResult) -> Void in
            
            }) { (error) -> Void in
                
        }
    }
    
    public class func request(var url: String, params: String?, body: AnyObject?, method: String, headers : NSDictionary? = nil,  success: (jsonResult: AnyObject?) -> Void,
        failure: ((error: NSError) -> Void)?) {
            
          //  var url = baseURL + uri
            if params != nil {
                url += "?" + params!
            }
            
            let finalURL: NSURL = NSURL(string: url)!
            let request : NSMutableURLRequest
            
                request = NSMutableURLRequest(URL: finalURL)
    
            
            request.URL = finalURL
            request.HTTPMethod = method
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if headers !=  nil && headers!.count > 0 {
                for header in headers! {
                    request.setValue(header.value as! String, forHTTPHeaderField: header.key as! String)
                }
            }
            
            if body != nil {
                request.HTTPBody = (body as! NSString).dataUsingEncoding(NSUTF8StringEncoding)
            }
            

            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
            }
    }
    
}
