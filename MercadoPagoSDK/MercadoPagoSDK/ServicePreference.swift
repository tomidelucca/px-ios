//
//  ServicePreference.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 1/24/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

open class ServicePreference : NSObject{
    
    var customerURL: NSURL?
    var customerAdditionalInfo: NSDictionary?
    var checkoutPreferenceURL: NSURL?
    var checkoutAdditionalInfo: NSDictionary?
    var paymentURL: NSURL
    var paymentAdditionalInfo: NSDictionary?
    
    
    public init(customerURL: NSURL? = nil, customerAdditionalInfo: NSDictionary? = nil, checkoutPreferenceURL: NSURL? = nil, checkoutAdditionalInfo: NSDictionary? = nil, paymentURL: NSURL = NSURL(string: MercadoPago.MP_PAYMENTS_URI, relativeTo: URL(string: MercadoPago.MP_API_BASE_URL))!, paymentAdditionalInfo: NSDictionary? = nil){
        self.paymentURL = paymentURL
        
    }

    public func setGetCustomer(URL: String, additionalInfo: NSDictionary? = nil){
        if let customerURL = NSURL(string: URL) {
            self.customerURL = customerURL
        }
        customerAdditionalInfo = additionalInfo
    }
    
    public func setCreatePayment(URL: String, additionalInfo: NSDictionary? = nil){
        if let paymentURL = NSURL(string: URL) {
            self.paymentURL = paymentURL
        }
        paymentAdditionalInfo = additionalInfo
    }
    
    public func setCreateCheckoutPreference(URL: String, additionalInfo: NSDictionary? = nil){
        if let checkoutPreferenceURL = NSURL(string: URL) {
            self.checkoutPreferenceURL = checkoutPreferenceURL
        }
        checkoutAdditionalInfo = additionalInfo
    }
    
    public func getCustomerURL() -> NSURL?{
        return customerURL
    }
    
    public func getCustomerAddionalInfo() -> NSDictionary? {
        return customerAdditionalInfo
    }
    
    public func getPaymentURL() -> NSURL{
        return paymentURL
    }
    
    public func getPaymentAddionalInfo() -> NSDictionary? {
        return paymentAdditionalInfo
    }
    
    public func getCheckoutPreferenceURL() -> NSURL?{
        return checkoutPreferenceURL
    }
    
    public func getCheckoutAddionalInfo() -> NSDictionary? {
        return checkoutAdditionalInfo
    }
    
    public func isGetCustomerSet() -> Bool{
        if let customerURL = customerURL {
            return !String.isNullOrEmpty(customerURL.absoluteString)
        }
        return false
    }
    public func isCheckoutPreferenceSet() -> Bool{
        if let checkoutPreferenceURL = checkoutPreferenceURL {
            return !String.isNullOrEmpty(checkoutPreferenceURL.absoluteString)
        }
        return false
    }

}
