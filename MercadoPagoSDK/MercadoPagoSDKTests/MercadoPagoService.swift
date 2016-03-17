//
//  MercadoPagoService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 8/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class MercadoPagoService: NSObject {
    
    var baseURL : String!
    init (baseURL : String) {
        super.init()
        self.baseURL = baseURL
    }
    
    public func request(uri: String, params: String?, body: AnyObject?, method: String, success: (jsonResult: AnyObject?) -> Void,
        failure: ((error: NSError) -> Void)?) {
            var finalUri = uri
            if params != nil {
                finalUri = finalUri + "?" + params!
            }
            do {
                let jsonResponse = try MockManager.getMockResponseFor(finalUri, method: method)
                if (jsonResponse != nil && jsonResponse!["error"] != nil){
                    failure!(error: NSError(domain: uri, code: 400, userInfo: nil))
                    return
                }
                success(jsonResult: jsonResponse)
            } catch {
                failure!(error: NSError(domain: uri, code: 400, userInfo: nil))
            }
            
    }
}
