//
//  ServicePreference.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 1/24/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

open class ServicePreference : NSObject{
    
    var customerURL: String?
    var customerURI = ""
    var customerAdditionalInfo: NSDictionary?
    var checkoutPreferenceURL: String?
    var checkoutPreferenceURI = ""
    var checkoutAdditionalInfo: NSDictionary?
    var paymentURL: String = MP_API_BASE_URL
    var paymentURI: String = MP_PAYMENTS_URI + "?api_version=" + API_VERSION
    var paymentAdditionalInfo: NSDictionary?
    
    internal static let MP_ALPHA_ENV = "/gamma"
    internal static var MP_TEST_ENV = "/beta"
    internal static let MP_PROD_ENV = "/v1"
    internal static let API_VERSION = "1.3.X"
    
    internal static let MP_ENVIROMENT = MP_TEST_ENV  + "/checkout"
    
    internal static let MP_OP_ENVIROMENT = "/v1"
    
    internal static let MP_ALPHA_API_BASE_URL : String =  "http://api.mp.internal.ml.com"
    internal static let MP_API_BASE_URL_PROD : String =  "https://api.mercadopago.com"
    
    internal static let MP_API_BASE_URL : String =  MP_API_BASE_URL_PROD
    
    internal static let MP_CUSTOMER_URI = "/customers?preference_id="
    internal static let MP_PAYMENTS_URI = MP_ENVIROMENT + "/payments"
    
    internal static let MP_PAYMENTS_URL = MP_API_BASE_URL + MP_PAYMENTS_URI + "?api_version=" + API_VERSION
    
    /*public init(customerURL: String = "", customerAdditionalInfo : [String:String]? = nil, checkoutPreferenceURL: String = "", checkoutAdditionalInfo : NSDictionary? = nil, paymentURL: String = MP_PAYMENTS_URL, paymentAdditionalInfo : NSDictionary? = nil){
        
        self.customerURL = customerURL
        self.checkoutPreferenceURL = checkoutPreferenceURL
        self.checkoutAdditionalInfo = checkoutAdditionalInfo
        self.paymentURL = paymentURL
        self .paymentAdditionalInfo = paymentAdditionalInfo
        
        if let customerAdditionalInfo = customerAdditionalInfo {
            self.customerAdditionalInfo = customerAdditionalInfo as NSDictionary
        }
        
    }*/

    public func setGetCustomer(baseURL: String, URI: String , additionalInfo: [String:String]? = nil) {
        customerURL = baseURL
        customerURI = URI
        if let additionalInfo = additionalInfo {
            customerAdditionalInfo = additionalInfo as NSDictionary
        }
        
    }
    
    public func setCreatePayment(baseURL: String, URI: String, additionalInfo: NSDictionary? = nil) {
        paymentURL = baseURL
        paymentURI = URI
        paymentAdditionalInfo = additionalInfo
        
    }
    
    public func setCreatePreference(baseURL: String, URI: String, additionalInfo: NSDictionary? = nil) {
        checkoutPreferenceURL = baseURL
        checkoutPreferenceURI = URI
        checkoutAdditionalInfo = additionalInfo
        
    }
    
    public func getCustomerURL() -> String? {
        return customerURL
    }
    
    public func getCustomerURI() -> String {
        return customerURI
    }
    
    public func getCustomerAddionalInfo() -> String {
        if let  customerAdditionalInfo = customerAdditionalInfo {
            return customerAdditionalInfo.parseToQuery()
        }
        return ""
    }
    
    public func getPaymentURL() -> String{
        return paymentURL
    }
    
    public func getPaymentURI() -> String {
        return paymentURI
    }
    
    public func getPaymentAddionalInfo() -> String {
        if let paymentAdditionalInfo = paymentAdditionalInfo?.toJsonString(){
            return paymentAdditionalInfo
        }
        return ""
    }
    
    public func getCheckoutPreferenceURL() -> String?{
        return checkoutPreferenceURL
    }
    
    public func getCheckoutPreferenceURI() -> String {
        return checkoutPreferenceURI
    }
    
    public func getCheckoutAddionalInfo() -> String {
        if let checkoutAdditionalInfo = checkoutAdditionalInfo?.toJsonString(){
            return checkoutAdditionalInfo
        }
        return ""
    }
    
    public func isGetCustomerSet() -> Bool{
        return !String.isNullOrEmpty(customerURL)
    }
    public func isCheckoutPreferenceSet() -> Bool{
        return !String.isNullOrEmpty(checkoutPreferenceURL)
    }

}
