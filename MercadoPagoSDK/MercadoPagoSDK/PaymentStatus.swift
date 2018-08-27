//
//  PaymentStatus.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/22/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

public enum PXPaymentStatus: String {
    case APPROVED = "approved"
    case REJECTED = "rejected"
    case RECOVERY = "recovery"
    case IN_PROCESS = "in_process"
    case PENDING = "pending"
}

public enum PXRejectedStatusDetail: String {
    case HIGH_RISK = "rejected_high_risk"
    case OTHER_REASON = "cc_rejected_other_reason"
    case MAX_ATTEMPTS = "cc_rejected_max_attempts"
    case CARD_DISABLE = "cc_rejected_card_disabled"
    case BAD_FILLED_OTHER = "cc_rejected_bad_filled_other"
    case BAD_FILLED_CARD_NUMBER = "cc_rejected_bad_filled_card_number"
    case BAD_FILLED_SECURITY_CODE = "cc_rejected_bad_filled_security_code"
    case BAD_FILLED_DATE = "cc_rejected_bad_filled_date"
    case CALL_FOR_AUTH = "cc_rejected_call_for_authorize"
    case DUPLICATED_PAYMENT = "cc_rejected_duplicated_payment"
    case INSUFFICIENT_AMOUNT = "cc_rejected_insufficient_amount"
    case INSUFFICIENT_DATA = "rejected_insufficient_data"
    case REJECTED_BY_BANK = "rejected_by_bank"
    case INVALID_ESC = "invalid_esc"
    case REJECTED_PLUGIN_PM = "cc_rejected_plugin_pm"
}

public enum PXPendingStatusDetail: String {
    case CONTINGENCY = "pending_contingency"
    case REVIEW_MANUAL = "pending_review_manual"
    case WAITING_PAYMENT = "pending_waiting_payment"

}
