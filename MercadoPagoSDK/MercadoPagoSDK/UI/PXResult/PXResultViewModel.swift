//
//  PXResultViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 20/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

internal class PXResultViewModel: PXResultViewModelInterface {

    var paymentResult: PaymentResult
    var instructionsInfo: PXInstructions?
    var preference: PXPaymentResultConfiguration
    var callback: ((PaymentResult.CongratsState) -> Void)!
    let amountHelper: PXAmountHelper

    let warningStatusDetails = [PXRejectedStatusDetail.INVALID_ESC, PXRejectedStatusDetail.CALL_FOR_AUTH, PXRejectedStatusDetail.BAD_FILLED_CARD_NUMBER, PXRejectedStatusDetail.CARD_DISABLE, PXRejectedStatusDetail.INSUFFICIENT_AMOUNT, PXRejectedStatusDetail.BAD_FILLED_DATE, PXRejectedStatusDetail.BAD_FILLED_SECURITY_CODE, PXRejectedStatusDetail.BAD_FILLED_OTHER]

    init(amountHelper: PXAmountHelper, paymentResult: PaymentResult, instructionsInfo: PXInstructions? = nil, resultConfiguration: PXPaymentResultConfiguration = PXPaymentResultConfiguration()) {
        self.paymentResult = paymentResult
        self.instructionsInfo = instructionsInfo
        self.preference =  resultConfiguration
        self.amountHelper = amountHelper
    }

    func getPaymentData() -> PXPaymentData {
        return self.paymentResult.paymentData!
    }

    func setCallback(callback: @escaping ((PaymentResult.CongratsState) -> Void)) {
        self.callback = callback
    }

    func getPaymentStatus() -> String {
        return self.paymentResult.status
    }

    func getPaymentStatusDetail() -> String {
        return self.paymentResult.statusDetail
    }

    func getPaymentId() -> String? {
        return self.paymentResult.paymentId
    }
    func isCallForAuth() -> Bool {
        return self.paymentResult.isCallForAuth()
    }

    func primaryResultColor() -> UIColor {
        return ResourceManager.shared.getResultColorWith(status: paymentResult.status, statusDetail: paymentResult.statusDetail)
    }
}

// MARK: Tracking
extension PXResultViewModel {

    func getTrackingProperties() -> [String: Any] {
        var properties: [String: Any] = [:]
        properties["style"] = "generic"
        properties["amount"] = amountHelper.amountToPay
        properties["currency_id"] = SiteManager.shared.getCurrency().id
        properties["payment_method_id"] = amountHelper.paymentData.paymentMethod?.getPaymentIdForTracking()
        properties["payment_method_type"] = amountHelper.paymentData.paymentMethod?.getPaymentTypeForTracking()
        properties["payment_id"] = paymentResult.paymentId
        properties["payment_status"] = paymentResult.status
        properties["payment_status_details"] = paymentResult.statusDetail
        properties["issuer_id"] = amountHelper.paymentData.issuer?.id

        if paymentResult.status == PXPaymentStatus.REJECTED.rawValue {
            properties["recoverable"] = getActionButton() != nil
            properties["message"] = titleHeader().string
        }

        var extraInfo: [String: Any] = [:]

        if let cardId = paymentResult.cardId {
            let cardIdsEsc = PXTrackingStore.sharedInstance.getData(forKey: PXTrackingStore.cardIdsESC) as? [String] ?? []
            extraInfo["card_id"] = cardId
            extraInfo["esc"] = cardIdsEsc.contains(cardId)
        }

        // TODO checkear esto
        if instructionsInfo != nil {
            extraInfo["reference"] = instructionsInfo?.instructions.first?.references?.first
        }

        properties["extra_info"] = extraInfo
        return properties
    }

    func getTrackingPath() -> String {
        let paymentStatus = PXPaymentStatus.IN_PROCESS.rawValue
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
