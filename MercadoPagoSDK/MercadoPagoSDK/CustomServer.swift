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

    open class func getCustomer(url: String, uri: String, additionalInfo: [String:AnyObject]? = nil, _ success: @escaping (_ customer: Customer) -> Void, failure: ((_ error: NSError) -> Void)?) {
        
        let service: CustomService = CustomService(baseURL: url, URI: uri)
        
        var additionalInfoString: String = ""
        if let additional = additionalInfo {
            additionalInfoString = JSONHandler.jsonCoding(additional)
        }
        
        service.getCustomer(params: additionalInfoString, success: {(jsonResult: AnyObject?) -> Void in
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

    open class func createPayment(paymentUrl: String, paymentUri: String, paymentBody: NSDictionary, success: @escaping (_ payment: Payment) -> Void, failure: ((_ error: NSError) -> Void)?) {
        let service: CustomService = CustomService(baseURL: paymentUrl, URI: paymentUri)

        var body = ""
        if !NSDictionary.isNullOrEmpty(paymentBody) {
            body = Utils.append(firstJSON: paymentBody.toJsonString(), secondJSON: MercadoPagoCheckoutViewModel.servicePreference.getPaymentAddionalInfo())
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
                        failure!(NSError(domain: "mercadopago.sdk.customServer.createPayment", code: MercadoPago.ERROR_PAYMENT, userInfo: ["message": "PAYMENT_ERROR".localized]))
                    }

                }
            } else {
                if failure != nil {
                    failure!(NSError(domain: "mercadopago.sdk.customServer.createPayment", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
                }
            }
        }, failure: failure)
    }

    open class func createCheckoutPreference(url: String, uri: String, bodyInfo: [String:AnyObject]? = nil, success: @escaping (_ checkoutPreference: CheckoutPreference) -> Void, failure: ((_ error: NSError) -> Void)?) {

        let service: CustomService = CustomService(baseURL: url, URI: uri)
        
        var bodyString: String = ""
        if let body = bodyInfo {
            bodyString = JSONHandler.jsonCoding(body)
        }

        service.createPreference(body: bodyString, success: { (jsonResult) in
            var checkoutPreference : CheckoutPreference? = nil

            if let preferenceDic = jsonResult as? NSDictionary {
                if preferenceDic["error"] != nil && failure != nil {
                    failure!(NSError(domain: "mercadopago.customServer.createCheckoutPreference", code: MercadoPago.ERROR_API_CODE, userInfo: ["message": "PREFERENCE_ERROR".localized]))
                } else {
                    if preferenceDic.allKeys.count > 0 {
                        checkoutPreference = CheckoutPreference.fromJSON(preferenceDic)
                        success(checkoutPreference!)
                    }
                }
            } else {
                failure?(NSError(domain: "mercadopago.sdk.customServer.createCheckoutPreference", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
            }
        }, failure: failure)
    }

    open class func getDirectDiscount(merchantURL: String = MercadoPagoCheckoutViewModel.servicePreference.getDiscountURL(), merchantURI: String = MercadoPagoCheckoutViewModel.servicePreference.getDiscountURI(), transactionAmount: Double, payerEmail: String?, addtionalInfo: NSDictionary?, success: @escaping (_ discountCoupon: DiscountCoupon?) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        getCodeDiscount(merchantURL: merchantURL, merchantURI: merchantURI, transactionAmount: transactionAmount, discountCode: nil, payerEmail: payerEmail, addtionalInfo: addtionalInfo, success: success, failure: failure)
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
