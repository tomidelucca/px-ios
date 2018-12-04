//
//  PXReviewViewModel+Tracking.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 03/12/2018.
//

import Foundation

// MARK: Tracking
extension PXReviewViewModel {

    func getConfirmEventProperties() -> [String: Any] {
        var properties: [String: Any] = amountHelper.paymentData.getPaymentDataForTracking()
        properties["review_type"] = "traditional"
        return properties
    }

    func getScreenProperties() -> [String: Any] {
        var properties: [String: Any] = amountHelper.paymentData.getPaymentDataForTracking()

        properties["discount"] = amountHelper.getDiscountForTracking()
        properties["currency_id"] = SiteManager.shared.getCurrency().id
        properties["total_amount"] = amountHelper.amountToPay
        var itemsDic: [Any] = []
        for item in amountHelper.preference.items {
            itemsDic.append(item.getItemForTracking())
        }
        properties["items"] = itemsDic
        properties["charges"] = self.amountHelper.chargeRuleAmount
        return properties
    }

    func trackChangePaymentMethodEvent() {
        // No tracking for change payment method event in review view controller for now
    }
}
