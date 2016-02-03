//
//  PaymentMethodSearchService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentMethodSearchService: MercadoPagoService {
    
    //TODO : verify URIS
    public let MP_SEARCH_BASE_URL = "http://private-6c157-chonativof2.apiary-mock.com"
    public let MP_SEARCH_PAYMENTS_URI = "/checkout/v1/payment_methods/search/options?public_key=6c0d81bc-99c1-4de8-9976-c8d1d62cd4f2"
    
    public init(){
        super.init(baseURL: MP_SEARCH_BASE_URL)
    }
    
    public func getPaymentMethods(excludedPaymentTypes : Set<PaymentTypeId>?, excludedPaymentMethods : [String]?, success: (paymentMethodSearch: PaymentMethodSearch) -> Void, failure: ((error: NSError) -> Void)?) {
        var params = "public_key=" + MercadoPagoContext.publicKey()
        if excludedPaymentTypes != nil {
            params = "&excluded_payment_types=[" + String(excludedPaymentTypes) + "]"
        }
        if excludedPaymentMethods != nil {
            let excludedPaymentMethodsParams = excludedPaymentMethods!.joinWithSeparator(",")
            params = "&excluded_payment_methods=[" + excludedPaymentMethodsParams + "]"
        }
        self.request(MP_SEARCH_PAYMENTS_URI, params: params, body: nil, method: "GET", success: { (jsonResult) -> Void in
            success(paymentMethodSearch : PaymentMethodSearch.fromJSON(jsonResult as! NSDictionary))
            },  failure: { (error) -> Void in
                
        })
    }
    

}
