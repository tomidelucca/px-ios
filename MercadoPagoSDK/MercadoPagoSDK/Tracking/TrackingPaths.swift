//
//  TrackingPaths.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 7/7/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

internal struct TrackingPaths {

    private static let pxTrack = "/px_checkout"
    private static let payments = "/payments"
    private static let selectMethod = "/select_method"
    private static let addPaymentMethod = "/add_payment_method"

    static let initTrack = pxTrack + "/init"

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

// MARK: Screens
extension TrackingPaths {

    internal struct Screens {
        private static let from = "#from="
        private static let refer = "#refer="

        // Payment Vault Path
        static func getPaymentVaultPath() -> String {
            return pxTrack + payments + selectMethod
        }

         // Review and Confirm Path
        static func getReviewAndConfirmPath() -> String {
            return pxTrack + "/review/traditional"
        }

        // Bank Deaks Path
        static func getBankDealsPath() -> String {
            return pxTrack + addPaymentMethod + "/promotions"
        }

        // Terms and Conditions Path
        static func getTermsAndConditionPath() -> String {
            return pxTrack + addPaymentMethod + "/promotions/terms_and_conditions"
        }

        // Issuers Paths
        static func getIssuersPath() -> String {
            return pxTrack + payments + "/card_issuer"
        }

        // Installments Paths
        static func getInstallmentsPath() -> String {
            return pxTrack + payments + "/installments"
        }

        // Discount details path
        static func getDiscountDetailPath() -> String {
            return pxTrack + payments + selectMethod + "/applied_discount"
        }

        // Error path
        static func getErrorPath() -> String {
            return "/wallet_error"
        }

        // Available payment methods paths
        static func getAvailablePaymentMethodsPath(paymentTypeId: String) -> String {
            return pxTrack + addPaymentMethod + "/" + paymentTypeId + "/number/error_more_info"
        }

        // Security Code Paths
        static func getSecurityCodePath(paymentTypeId: String, referScreen: String) -> String {
            return pxTrack + payments + selectMethod + "/" + paymentTypeId + refer + referScreen
        }
    }
}

// MARK: CardForm Flow Screen Paths
extension TrackingPaths.Screens {
    internal struct CardForm {
        private static let number = "/number"
        private static let name = "/name"
        private static let expirationDate = "/expiration_date"
        private static let cvv = "/cvv"
        private static let identification = "/document"

        static let cardForm = TrackingPaths.pxTrack + TrackingPaths.addPaymentMethod

        static func getCardNumberPath(paymentTypeId: String) -> String {
            return cardForm + "/" + paymentTypeId + number
        }

        static func getCardNamePath(paymentTypeId: String) -> String {
            return cardForm + "/" + paymentTypeId + name
        }

        static func getExpirationDatePath(paymentTypeId: String) -> String {
            return cardForm + "/" + paymentTypeId + expirationDate
        }

        static func getCvvPath(paymentTypeId: String) -> String {
            return cardForm + "/" + paymentTypeId + cvv
        }

        static func getIdentificationPath(paymentTypeId: String) -> String {
            return cardForm + "/" + paymentTypeId + identification
        }
    }
}

// MARK: Boleto Flow Screen Paths
extension TrackingPaths.Screens {
    internal struct Boleto {
        private static let cpf = "/cpf"
        private static let name = "/name"
        private static let lastName = "/lastname"

        private static let boleto = TrackingPaths.pxTrack + TrackingPaths.selectMethod + "/ticket"

        static func getCpfPath() -> String {
            return boleto + cpf
        }

        static func getNamePath() -> String {
            return boleto + name
        }

        static func getLastNamePath() -> String {
            return boleto + lastName
        }
    }
}

// MARK: Payment Result Screen Paths
extension TrackingPaths.Screens {
    internal struct PaymentResult {
        private static let success = "/success"
        private static let furtherAction = "/further_action_needed"
        private static let error = "/error"

        private static let result = TrackingPaths.pxTrack + "/result"

        static func getSuccessPath() -> String {
            return result + success
        }

        static func getFurtherActionPath() -> String {
            return result + furtherAction
        }

        static func getErrorPath() -> String {
            return result + error
        }
    }
}
