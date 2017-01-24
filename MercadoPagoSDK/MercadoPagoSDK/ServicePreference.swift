//
//  ServicePreference.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 1/24/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

open class ServicePreference : NSObject{
    
    var customerURL = ""
    var customerAdditionalInfo: NSDictionary?
    var checkoutPreferenceURL = ""
    var checkoutAdditionalInfo: NSDictionary?
    var paymentURL = ""
    var paymentAdditionalInfo: NSDictionary?

    public func setGetCustomer(URL: String, additionalInfo: NSDictionary?){
        customerURL = URL
        customerAdditionalInfo = additionalInfo
        
    }
    
    public func setCreatePayment(URL: String, additionalInfo: NSDictionary?){
        paymentURL = URL
        paymentAdditionalInfo = additionalInfo
        
    }
    
    public func setCreatePreference(URL: String, additionalInfo: NSDictionary?){
        checkoutPreferenceURL = URL
        checkoutAdditionalInfo = additionalInfo
        
    }
    
    public func getCustomerURL() -> String{
        return customerURL
    }
    
    public func getCustomerAddionalInfo() -> NSDictionary? {
        return customerAdditionalInfo
    }
    
    public func getPaymentURL() -> String{
        return paymentURL
    }
    
    public func getPaymentAddionalInfo() -> NSDictionary? {
        return paymentAdditionalInfo
    }
    
    public func getCheckoutPreferenceURL() -> String{
        return checkoutPreferenceURL
    }
    
    public func getCheckoutAddionalInfo() -> NSDictionary? {
        return checkoutAdditionalInfo
    }

}
