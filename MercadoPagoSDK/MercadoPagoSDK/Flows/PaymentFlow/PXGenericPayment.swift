//
//  PXGenericPayment.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 26/06/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

@objcMembers
open class PXGenericPayment: NSObject {
    /// :nodoc:
    @objc public enum RemotePaymentStatus: Int {
        case APPROVED
        case REJECTED
    }

    open let paymentId: String?
    open let status: String
    open let statusDetail: String

    @objc public init(status: String, statusDetail: String, paymentId: String? = nil) {
        self.status = status
        self.statusDetail = statusDetail
        self.paymentId = paymentId
    }

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
