//
//  MerchantService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MerchantService : MercadoPagoService {
    
    public var data: NSMutableData = NSMutableData()
    
    override init (baseURL : String) {
        super.init(baseURL: MercadoPagoContext.baseURL())
    }

    public func getCustomer(method : String = "GET", merchant_access_token : String, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(MercadoPagoContext.customerURI(), params: "merchant_access_token=" + merchant_access_token, body: nil, method: method, success: success, failure: failure)
    }
    
    public func createPayment(method : String = "POST", payment : MerchantPayment, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(MercadoPagoContext.paymentURI(), params: nil, body: payment.toJSONString(), method: method, success: success, failure: failure)
    }
    
    public func createPreference(method : String = "POST", preference : CheckoutPreference, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(MercadoPagoContext.preferenceURI(), params: nil, body: preference.toJSONString(), method: method, success: success, failure: failure)
    }
}