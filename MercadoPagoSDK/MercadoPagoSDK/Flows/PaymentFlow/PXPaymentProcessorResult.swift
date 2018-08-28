//
//  PXPaymentProcessorResult.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 26/06/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

/** :nodoc: */
@objcMembers
open class PXPaymentProcessorResult: NSObject {
    @objc public enum RemotePaymentStatus: Int {
        case APPROVED
        case REJECTED
    }

    let status: String
    let statusDetail: String
    let receiptId: String?

    @objc public init(status: String, statusDetail: String, receiptId: String? = nil) {
        self.status = status
        self.statusDetail = statusDetail
        self.receiptId = receiptId
    }

    public init(paymentStatus: PXPaymentProcessorResult.RemotePaymentStatus, statusDetail: String, receiptId: String? = nil) {
        var paymentStatusStrDefault = PXPaymentStatus.REJECTED.rawValue

        if paymentStatus == .APPROVED {
            paymentStatusStrDefault = PXPaymentStatus.APPROVED.rawValue
        }
        self.status = paymentStatusStrDefault
        self.statusDetail = statusDetail
        self.receiptId = receiptId
    }
}
