//
//  PXGenericPayment.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 26/06/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

/**
 Use this object in order to notify you own custom payment using `PXPaymentProcessor`.
 */
@objcMembers
open class PXGenericPayment: NSObject {
    /// :nodoc:
    @objc public enum RemotePaymentStatus: Int {
        case APPROVED
        case REJECTED
    }

    // MARK: Public accessors.
    /**
     id related to your payment.
     */
    open let paymentId: String?

    /**
     Status of your payment.
     */
    open let status: String

    /**
     Status detail of your payment.
     */
    open let statusDetail: String


    // MARK: Init.
    /**
     - parameter status: Status of payment.
     - parameter statusDetail: Status detail of payment.
     - parameter paymentId: Id of payment.
     */
    @objc public init(status: String, statusDetail: String, paymentId: String? = nil) {
        self.status = status
        self.statusDetail = statusDetail
        self.paymentId = paymentId
    }

    /// :nodoc:
    public init(paymentStatus: PXGenericPayment.RemotePaymentStatus, statusDetail: String, receiptId: String? = nil) {
        var paymentStatusStrDefault = PXPaymentStatus.REJECTED.rawValue

        if paymentStatus == .APPROVED {
            paymentStatusStrDefault = PXPaymentStatus.APPROVED.rawValue
        }
        self.status = paymentStatusStrDefault
        self.statusDetail = statusDetail
        self.paymentId = receiptId
    }
}
