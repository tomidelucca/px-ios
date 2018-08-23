//
//  PaymentResult.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

/** :nodoc: */
@objcMembers open class PaymentResult: NSObject {

    @objc
    public enum CongratsState: Int {
        case approved = 0
        case cancel_SELECT_OTHER = 1
        case cancel_RETRY = 2
        case cancel_RECOVER = 3
        case call_FOR_AUTH = 4
    }

    let warningStatusDetails = [PXRejectedStatusDetail.INVALID_ESC, PXRejectedStatusDetail.CALL_FOR_AUTH, PXRejectedStatusDetail.BAD_FILLED_CARD_NUMBER, PXRejectedStatusDetail.CARD_DISABLE, PXRejectedStatusDetail.INSUFFICIENT_AMOUNT, PXRejectedStatusDetail.BAD_FILLED_DATE, PXRejectedStatusDetail.BAD_FILLED_SECURITY_CODE, PXRejectedStatusDetail.BAD_FILLED_OTHER]

    open var paymentData: PaymentData?
    open var status: String
    open var statusDetail: String
    open var payerEmail: String?
    open var paymentId: String?
    open var statementDescription: String?

    public init (payment: Payment, paymentData: PaymentData) {
        self.status = payment.status
        self.statusDetail = payment.statusDetail
        self.paymentData = paymentData
        self.paymentId = payment.paymentId
        self.payerEmail = paymentData.payer?.email
        self.statementDescription = payment.statementDescriptor
    }

    public init (status: String, statusDetail: String, paymentData: PaymentData, payerEmail: String?, paymentId: String?, statementDescription: String?) {
        self.status = status
        self.statusDetail = statusDetail
        self.paymentData = paymentData
        self.payerEmail = payerEmail
        self.paymentId = paymentId
        self.statementDescription = statementDescription
    }

    func isCallForAuth() -> Bool {
        return self.statusDetail == PXRejectedStatusDetail.CALL_FOR_AUTH
    }

    func isApproved() -> Bool {
        return self.status == PXPaymentStatus.APPROVED
    }

    func isPending() -> Bool {
        return self.status == PXPaymentStatus.PENDING
    }

    func isInProcess() -> Bool {
        return self.status == PXPaymentStatus.IN_PROCESS
    }

    func isRejected() -> Bool {
        return self.status == PXPaymentStatus.REJECTED
    }

    func isInvalidESC() -> Bool {
        return self.statusDetail == PXRejectedStatusDetail.INVALID_ESC
    }

    func isReviewManual() -> Bool {
        return self.statusDetail == PXPendingStatusDetail.REVIEW_MANUAL
    }

    func isWaitingForPayment() -> Bool {
        return self.statusDetail == PXPendingStatusDetail.WAITING_PAYMENT
    }
}

// MARK: Congrats logic
extension PaymentResult {
    func isAccepted() -> Bool {
        return isApproved() || isInProcess() || isPending()
    }

    func isWarning() -> Bool {
        if !isRejected() {
            return false
        }
        if warningStatusDetails.contains(statusDetail) {
            return true
        }
        return false
    }

    func isError() -> Bool {
        if !isRejected() {
            return false
        }
        return !isWarning()
    }
}
