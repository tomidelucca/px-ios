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

            if let custDic = jsonResult as? NSDictionary {
                if custDic["error"] != nil {
                    if failure != nil {
                        failure!(NSError(domain: "mercadopago.sdk.customServer.getCustomer", code: MercadoPago.ERROR_API_CODE, userInfo: custDic as! [AnyHashable: AnyObject]))
                    }
                } else {
                    success(Customer.fromJSON(custDic))
                }
            } else {
                if failure != nil {
                    failure!(NSError(domain: "mercadopago.sdk.customServer.getCustomer", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
                }
            }
        }, failure: failure)
    }

    open class func createPayment(url: String, uri: String, paymentData: NSDictionary, query: NSDictionary?, success: @escaping (_ payment: Payment) -> Void, failure: ((_ error: NSError) -> Void)?) {
        let service: CustomService = CustomService(baseURL: url, URI: uri)

        var queryString = ""
        if let q = query, !NSDictionary.isNullOrEmpty(query) {
            queryString = q.toJsonString()
        }

        var body = ""
        if !NSDictionary.isNullOrEmpty(paymentData) {
            body = Utils.append(firstJSON: paymentData.toJsonString(), secondJSON: queryString)
        }

        service.createPayment(body: body, success: {(jsonResult: AnyObject?) -> Void in

            if let paymentDic = jsonResult as? NSDictionary {
                if paymentDic["error"] != nil {
                    if paymentDic["status"] as? Int == ApiUtil.StatusCodes.PROCESSING.rawValue {
                        let inProcessPayment = Payment()
                        inProcessPayment.status = PaymentStatus.IN_PROCESS.rawValue
                        inProcessPayment.statusDetail = PendingStatusDetail.CONTINGENCY.rawValue
                        success(inProcessPayment)
                    } else if failure != nil {
                        failure!(NSError(domain: "mercadopago.sdk.customServer.createPayment", code: MercadoPago.ERROR_API_CODE, userInfo: paymentDic as! [AnyHashable: AnyObject]))
                    }
                } else {
                    if paymentDic.allKeys.count > 0 {
                        success(Payment.fromJSON(paymentDic))
                    } else {
                        if failure != nil {
                            failure!(NSError(domain: "mercadopago.sdk.customServer.createPayment", code: MercadoPago.ERROR_PAYMENT, userInfo: ["message": "PAYMENT_ERROR".localized]))
                        }
                    }
                }
            } else if failure != nil {
                failure!(NSError(domain: "mercadopago.sdk.customServer.createPayment", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
            }
        }, failure: failure)
    }

    open class func createCheckoutPreference(url: String, uri: String, bodyInfo: NSDictionary, success: @escaping (_ checkoutPreference: CheckoutPreference) -> Void, failure: ((_ error: NSError) -> Void)?) {

        let service: CustomService = CustomService(baseURL: url, URI: uri)

        let body: String = bodyInfo.toJsonString()

        service.createPreference(body: body, success: { (jsonResult) in

            if let preferenceDic = jsonResult as? NSDictionary {
                if preferenceDic["error"] != nil && failure != nil {
                    failure!(NSError(domain: "mercadopago.customServer.createCheckoutPreference", code: MercadoPago.ERROR_API_CODE, userInfo: ["message": "PREFERENCE_ERROR".localized]))
                } else {
                    if preferenceDic.allKeys.count > 0 {
                        success(CheckoutPreference.fromJSON(preferenceDic))
                    }
                }
            } else {
                failure?(NSError(domain: "mercadopago.sdk.customServer.createCheckoutPreference", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
            }
        }, failure: failure)
    }

    open class func getDirectDiscount(transactionAmount: Double, payerEmail: String?, url: String, uri: String, discountAdditionalInfo: NSDictionary?, success: @escaping (_ discountCoupon: DiscountCoupon?) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        getCodeDiscount(discountCode: nil, transactionAmount: transactionAmount, payerEmail: payerEmail, url: url, uri: uri, discountAdditionalInfo: discountAdditionalInfo, success: success, failure: failure)
    }

    open class func getCodeDiscount(discountCode: String?, transactionAmount: Double, payerEmail: String?, url: String, uri: String, discountAdditionalInfo: NSDictionary?, success: @escaping (_ discountCoupon: DiscountCoupon?) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        var addInfo: String? = nil
        if !NSDictionary.isNullOrEmpty(discountAdditionalInfo) {
            addInfo = discountAdditionalInfo?.parseToQuery()
        }
        let discountService = DiscountService(baseURL: url, URI: uri)

        discountService.getDiscount(amount: transactionAmount, code: discountCode, payerEmail: payerEmail, additionalInfo: addInfo, success: success, failure: failure)
    }

}
