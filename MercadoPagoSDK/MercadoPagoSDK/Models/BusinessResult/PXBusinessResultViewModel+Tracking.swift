//
//  PXBusinessResultViewModel+Tracking.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 13/12/2018.
//

import Foundation
// MARK: Tracking
extension PXBusinessResultViewModel {

    func getTrackingProperties() -> [String: Any] {
        var properties: [String: Any] = amountHelper.paymentData.getPaymentDataForTracking()
        properties["style"] = "custom"

        if let paymentId = getPaymentId() {
            properties["payment_id"] = Int64(paymentId)
        }
        properties["payment_status"] = businessResult.paymentStatus
        properties["payment_status_detail"] = businessResult.paymentStatusDetail

        return properties
    }

    func getTrackingPath() -> String {
        let paymentStatus = businessResult.paymentStatus
        var screenPath = ""
        if paymentStatus == PXPaymentStatus.APPROVED.rawValue || paymentStatus == PXPaymentStatus.PENDING.rawValue {
            screenPath = TrackingPaths.Screens.PaymentResult.getSuccessPath()
        } else if paymentStatus == PXPaymentStatus.IN_PROCESS.rawValue {
            screenPath = TrackingPaths.Screens.PaymentResult.getFurtherActionPath()
        } else if paymentStatus == PXPaymentStatus.REJECTED.rawValue {
            screenPath = TrackingPaths.Screens.PaymentResult.getErrorPath()
        }
        return screenPath
    }
}
