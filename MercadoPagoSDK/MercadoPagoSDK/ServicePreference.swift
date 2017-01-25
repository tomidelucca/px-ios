//
//  ServicePreference.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 1/24/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

open class ServicePreference : NSObject{
    
    var customerURL: String
    var customerAdditionalInfo: NSDictionary?
    var checkoutPreferenceURL: String
    var checkoutAdditionalInfo: NSDictionary?
    var paymentURL: String
    var paymentAdditionalInfo: NSDictionary?
    
    public init(customerURL: String = "", customerAdditionalInfo : [String:String]? = nil, checkoutPreferenceURL: String = "", checkoutAdditionalInfo : NSDictionary? = nil, paymentURL: String = MercadoPago.MP_PAYMENTS_URL, paymentAdditionalInfo : NSDictionary? = nil){
        
        self.customerURL = customerURL
        self.checkoutPreferenceURL = checkoutPreferenceURL
        self.checkoutAdditionalInfo = checkoutAdditionalInfo
        self.paymentURL = paymentURL
        self .paymentAdditionalInfo = paymentAdditionalInfo
        
        if let customerAdditionalInfo = customerAdditionalInfo {
            self.customerAdditionalInfo = customerAdditionalInfo as NSDictionary
        }
        
    }

    public func setGetCustomer(URL: String, additionalInfo: [String:String]? = nil){
        customerURL = URL
        if let additionalInfo = additionalInfo {
            customerAdditionalInfo = additionalInfo as NSDictionary
        }
        
    }
    
    public func setCreatePayment(URL: String, additionalInfo: NSDictionary? = nil){
        paymentURL = URL
        paymentAdditionalInfo = additionalInfo
        
    }
    
    public func setCreatePreference(URL: String, additionalInfo: NSDictionary? = nil){
        checkoutPreferenceURL = URL
        checkoutAdditionalInfo = additionalInfo
        
    }
    
    public func getCustomerURL() -> String{
        return customerURL
    }
    
    public func getCustomerAddionalInfo() -> String? {
        if let  customerAdditionalInfo = customerAdditionalInfo {
            return customerAdditionalInfo.parseToQuery()
        }
        return nil
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
    
    public func isGetCustomerSet() -> Bool{
        return !String.isNullOrEmpty(customerURL)
    }
    public func isCheckoutPreferenceSet() -> Bool{
        return !String.isNullOrEmpty(checkoutPreferenceURL)
    }

}
