//
//  CustomServer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

open class CustomServer: NSObject {

    open class func getCustomer(url: String, uri: String, additionalInfo: NSDictionary? = nil, _ success: @escaping (_ customer: Customer) -> Void, failure: ((_ error: NSError) -> Void)?) {
        
        let service: CustomService = CustomService(baseURL: url, URI: uri)
        
        var addInfo: String = ""
        if !NSDictionary.isNullOrEmpty(additionalInfo), let addInfoDict = additionalInfo {
            addInfo = addInfoDict.parseToQuery()
        }
        
        service.getCustomer(params: addInfo, success: {(jsonResult: AnyObject?) -> Void in
            var cust : Customer? = nil
            if let custDic = jsonResult as? NSDictionary {
                if custDic["error"] != nil {
                    if failure != nil {
                        failure!(NSError(domain: "mercadopago.sdk.customServer.getCustomer", code: MercadoPago.ERROR_API_CODE, userInfo: custDic as! [AnyHashable: AnyObject]))
                    }
                } else {
                    cust = Customer.fromJSON(custDic)
                    success(cust!)
                }
            } else {
                if failure != nil {
                    failure!(NSError(domain: "mercadopago.sdk.customServer.getCustomer", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
                }
            }
        }, failure: failure)
    }

    open class func createPayment(baseUrl: String, uri: String, paymentData: NSDictionary, query: String?, success: @escaping (_ payment: Payment) -> Void, failure: ((_ error: NSError) -> Void)?) {
        let service: CustomService = CustomService(baseURL: baseUrl, URI: uri)

        var queryString = ""
        if let q = query {
            queryString = q
        }

        var body = ""
        if !NSDictionary.isNullOrEmpty(paymentData) {
            body = Utils.append(firstJSON: paymentData.toJsonString(), secondJSON: queryString)
        }

        service.createPayment(body: body, success: {(jsonResult: AnyObject?) -> Void in
            var payment : Payment? = nil

            if let paymentDic = jsonResult as? NSDictionary {
                if paymentDic["error"] != nil {
                    if failure != nil {
                        failure!(NSError(domain: "mercadopago.sdk.customServer.createPayment", code: MercadoPago.ERROR_API_CODE, userInfo: paymentDic as! [AnyHashable: AnyObject]))
                    }
                } else {
                    if paymentDic.allKeys.count > 0 {
                        payment = Payment.fromJSON(paymentDic)
                        success(payment!)
                    } else {
                        if failure != nil {
                            failure!(NSError(domain: "mercadopago.sdk.customServer.createPayment", code: MercadoPago.ERROR_PAYMENT, userInfo: ["message": "PAYMENT_ERROR".localized]))
                        }
                    }
                }
            } else {
                if failure != nil {
                    failure!(NSError(domain: "mercadopago.sdk.customServer.createPayment", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
                }
            }
        }, failure: failure)
    }

    open class func createCheckoutPreference(url: String, uri: String, bodyInfo: NSDictionary, success: @escaping (_ checkoutPreference: CheckoutPreference) -> Void, failure: ((_ error: NSError) -> Void)?) {

        let service: CustomService = CustomService(baseURL: url, URI: uri)
        
        let body: String = bodyInfo.toJsonString()

        service.createPreference(body: body, success: { (jsonResult) in
            var checkoutPreference : CheckoutPreference

            if let preferenceDic = jsonResult as? NSDictionary {
                if preferenceDic["error"] != nil && failure != nil {
                    failure!(NSError(domain: "mercadopago.customServer.createCheckoutPreference", code: MercadoPago.ERROR_API_CODE, userInfo: ["message": "PREFERENCE_ERROR".localized]))
                } else {
                    if preferenceDic.allKeys.count > 0 {
                        checkoutPreference = CheckoutPreference.fromJSON(preferenceDic)
                        success(checkoutPreference)
                    }
                }
            } else {
                failure?(NSError(domain: "mercadopago.sdk.customServer.createCheckoutPreference", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
            }
        }, failure: failure)
    }

    open class func getDirectDiscount(transactionAmount: Double, payerEmail: String?, url: String = MercadoPagoCheckoutViewModel.servicePreference.getDiscountURL(), uri: String = MercadoPagoCheckoutViewModel.servicePreference.getDiscountURI(), discountAdditionalInfo: NSDictionary?, success: @escaping (_ discountCoupon: DiscountCoupon?) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        getCodeDiscount(merchantURL: url, merchantURI: uri, transactionAmount: transactionAmount, discountCode: nil, payerEmail: payerEmail, addtionalInfo: discountAdditionalInfo, success: success, failure: failure)
    }

    open class func getCodeDiscount(merchantURL: String = MercadoPagoCheckoutViewModel.servicePreference.getDiscountURL(), merchantURI: String = MercadoPagoCheckoutViewModel.servicePreference.getDiscountURI(), transactionAmount: Double, discountCode: String?, payerEmail: String?, addtionalInfo: NSDictionary?, success: @escaping (_ discountCoupon: DiscountCoupon?) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        var addInfo: String? = nil
        if !NSDictionary.isNullOrEmpty(addtionalInfo) {
            addInfo = addtionalInfo?.parseToQuery()
        }
        let discountService = DiscountService(baseURL: merchantURL, URI: merchantURI)

        discountService.getDiscount(amount: transactionAmount, code: discountCode, payerEmail: payerEmail, additionalInfo: addInfo, success: success, failure: failure)
    }

}
