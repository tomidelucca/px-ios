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
            
            let jsonResponse = MockManager.getMockFor("groups")
            success(jsonResult: jsonResponse)
    }
}
