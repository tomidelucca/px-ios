//
//  PaymentMethodSearchService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentMethodSearchService: MercadoPagoService {
    
    public let MP_SEARCH_BASE_URL = "http://private-6c157-chonativof2.apiary-mock.com"
    public let MP_SEARCH_PAYMENTS_URI = "/checkout/v1/payment_methods/search/options"
    
    public init(){
        super.init(baseURL: MP_SEARCH_BASE_URL)
    }
    
    public func getPaymentMethods(excludedPaymentTypes : [PaymentType]?, excludedPaymentMethods : [PaymentMethod]?, public_key: String, success: (paymentMethodSearch: PaymentMethodSearch) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(MP_SEARCH_PAYMENTS_URI, params: "public_key=" + public_key, body: nil, method: "GET", success: { (jsonResult) -> Void in
            success(paymentMethodSearch : PaymentMethodSearch.fromJSON(jsonResult as! NSDictionary))
            },  failure: { (error) -> Void in
                
        })
    }
}
