//
//  PXOneTapViewModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXOneTapViewModel: PXReviewViewModel {

    override func trackConfirmActionEvent() {
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingPaths.ACTION_CHECKOUT_CONFIRMED, screenId: "screenId", screenName: TrackingPaths.Screens.getOneTapPath())
    }

    override func trackInfo() {
        var properties: [String: String] = [TrackingPaths.METADATA_PAYMENT_METHOD_ID: self.amountHelper.paymentData.paymentMethod?.id ?? "", TrackingPaths.METADATA_PAYMENT_TYPE_ID: self.amountHelper.paymentData.paymentMethod?.paymentTypeId ?? "", TrackingPaths.METADATA_AMOUNT_ID: self.amountHelper.preferenceAmountWithCharges.stringValue]

        if let customerCard = paymentOptionSelected as? CustomerPaymentMethod {
            properties[TrackingPaths.METADATA_CARD_ID] = customerCard.customerPaymentMethodId
        }
        if let installments = self.amountHelper.paymentData.payerCost?.installments {
            properties[TrackingPaths.METADATA_INSTALLMENTS] = installments.stringValue
        }

        MPXTracker.sharedInstance.trackScreen(screenName: TrackingPaths.Screens.getOneTapPath(), properties: properties)
    }
}

// MARK: - Extra events
extension PXOneTapViewModel {
    func trackTapSummaryDetailEvent() {
        var properties: [String: String] = [String: String]()
        properties[TrackingPaths.Metadata.HAS_DISCOUNT] = hasDiscount().description
        properties[TrackingPaths.Metadata.INSTALLMENTS] = amountHelper.paymentData.getNumberOfInstallments().stringValue
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingPaths.Event.TAP_SUMMARY_DETAIL, screenId: "screenId", screenName: TrackingPaths.Screens.getOneTapPath(), properties: properties)
    }

    func trackTapBackEvent() {
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingPaths.Event.TAP_BACK, screenId: "screenId", screenName: TrackingPaths.Screens.getOneTapPath())
    }
}
