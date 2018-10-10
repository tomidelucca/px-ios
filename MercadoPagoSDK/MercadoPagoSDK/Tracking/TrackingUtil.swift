//
//  TrackingUtil.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 7/7/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

internal class TrackingUtil: NSObject {

    //Screen Names
    static let SCREEN_NAME_PAYMENT_VAULT = "/payments/select_method"
    static let SCREEN_NAME_REVIEW_AND_CONFIRM = "/review/traditional"
    static let SCREEN_NAME_PAYMENT_RESULT = "/result"
    static let SCREEN_NAME_BANK_DEALS = "/add_payment_method/promotions"
    static let SCREEN_NAME_CARD_FORM = "/add_payment_method"
    static let SCREEN_NAME_CARD_FORM_ISSUERS = "/payments/card_issuer"
    static let SCREEN_NAME_CARD_FORM_INSTALLMENTS = "/payments/installments"
    static let SCREEN_NAME_DISCOUNT_DETAIL = "payments/select_method/applied_discount"
    static let SCREEN_NAME_ERROR = "/wallet_error"

    //Sufix
    static let CARD_NUMBER = "/number"
    static let CARD_HOLDER_NAME = "/name"
    static let CARD_EXPIRATION_DATE = "/expiration_date"
    static let CARD_SECURITY_CODE = "/cvv"
    static let CARD_IDENTIFICATION = "/document"
    static let CARD_ISSUER = "/issuer"
    static let CARD_INSTALLMENTS = "/installments"
    static let CARD_SECURITY_CODE_VIEW = "/security_code"

    //Additional Info Keys
    static let METADATA_PAYMENT_METHOD_ID = "payment_method"
    static let METADATA_PAYMENT_TYPE_ID = "payment_type"
    static let METADATA_AMOUNT_ID = "purchase_amount"
    static let METADATA_ISSUER_ID = "issuer"
    static let METADATA_SHIPPING_INFO = "has_shipping"
    static let METADATA_PAYMENT_STATUS = "payment_status"
    static let METADATA_PAYMENT_ID = "payment_id"
    static let METADATA_PAYMENT_STATUS_DETAIL = "payment_status_detail"
    static let METADATA_PAYMENT_IS_EXPRESS = "is_express"
    static let METADATA_ERROR_STATUS = "error_status"
    static let METADATA_ERROR_CODE = "error_code"
    static let METADATA_ERROR_REQUEST = "error_request_origin"
    static let METATDATA_SECURITY_CODE_VIEW_REASON = "security_code_view_reason"
    static let METADATA_INSTALLMENTS = "installments"
    static let METADATA_CARD_ID = "card_id"
    static let METADATA_OPTIONS = "options"

    //Default values
    static let HAS_SHIPPING_DEFAULT_VALUE = "false"
    static let IS_EXPRESS_DEFAULT_VALUE = "false"
    static let NO_NAME_SCREEN = "NO NAME"
    static let NO_SCREEN_ID = "/"

    // MARK: Action events
    static let ACTION_CHECKOUT_CONFIRMED = "/checkout_confirmed"
}
