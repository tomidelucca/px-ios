//
//  PXPaymentTypes.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 24/08/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
public enum PXPaymentTypes: String {
    case DEBIT_CARD = "debit_card"
    case CREDIT_CARD = "credit_card"
    case ACCOUNT_MONEY = "account_money"
    case TICKET = "ticket"
    case BANK_TRANSFER = "bank_transfer"
    case ATM = "atm"
    case BITCOIN = "digital_currency"
    case PREPAID_CARD = "prepaid_card"
    case BOLBRADESCO = "bolbradesco"
    case PAYMENT_METHOD_PLUGIN = "payment_method_plugin"

    internal func isCard() -> Bool {
        return self == PXPaymentTypes.DEBIT_CARD || self == PXPaymentTypes.CREDIT_CARD || self == PXPaymentTypes.PREPAID_CARD
    }

    internal func isCreditCard() -> Bool {
        return self == PXPaymentTypes.CREDIT_CARD
    }

    internal func isPrepaidCard() -> Bool {
        return self == PXPaymentTypes.PREPAID_CARD
    }

    internal func isDebitCard() -> Bool {
        return self == PXPaymentTypes.DEBIT_CARD
    }

    internal func isOnlinePaymentType() -> Bool {
        return PXPaymentTypes.onlinePaymentTypes().contains(self.rawValue)
    }

    internal func isOfflinePaymentType() -> Bool {
        return PXPaymentTypes.offlinePaymentTypes().contains(self.rawValue)

    }

    internal static func onlinePaymentTypes() -> [String] {
        return [DEBIT_CARD.rawValue, CREDIT_CARD.rawValue, ACCOUNT_MONEY.rawValue, PREPAID_CARD.rawValue, PAYMENT_METHOD_PLUGIN.rawValue]
    }

    internal static func offlinePaymentTypes() -> [String] {
        return [ATM.rawValue, TICKET.rawValue, BANK_TRANSFER.rawValue]
    }

    internal static func isCard(paymentTypeId: String) -> Bool {
        guard let paymentTypeIdEnum = PXPaymentTypes(rawValue: paymentTypeId)
            else {
                return false
        }
        return paymentTypeIdEnum.isCard()
    }

    internal static func isOnlineType(paymentTypeId: String) -> Bool {

        guard let paymentTypeIdEnum = PXPaymentTypes(rawValue: paymentTypeId)
            else {
                return false
        }
        return paymentTypeIdEnum.isOnlinePaymentType()
    }

    internal static func isOfflineType(paymentTypeId: String) -> Bool {

        guard let paymentTypeIdEnum = PXPaymentTypes(rawValue: paymentTypeId)
            else {
                return false
        }
        return paymentTypeIdEnum.isOfflinePaymentType()
    }
}
