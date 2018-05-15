//
//  PXOneTapViewModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoPXTracking

final class PXOneTapViewModel: PXReviewViewModel {

    // Tracking overrides.
    override var screenName: String { return TrackingUtil.SCREEN_NAME_REVIEW_AND_CONFIRM_ONE_TAP }
    override var screenId: String { return TrackingUtil.SCREEN_ID_REVIEW_AND_CONFIRM_ONE_TAP }

    override func trackChangePaymentMethodEvent() {
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingUtil.ACTION_ONE_TAP_CHANGE_PAYMENT_METHOD, screenId: screenId, screenName: screenName)
    }

    override func trackConfirmActionEvent() {
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingUtil.ACTION_CHECKOUT_CONFIRMED, screenId: screenId, screenName: screenName)
    }

    override func trackInfo() {
        var properties: [String: String] = [TrackingUtil.METADATA_PAYMENT_METHOD_ID: paymentData.paymentMethod?.paymentMethodId ?? "", TrackingUtil.METADATA_PAYMENT_TYPE_ID: paymentData.paymentMethod?.paymentTypeId ?? "", TrackingUtil.METADATA_AMOUNT_ID: preference.getAmount().stringValue]

        if let customerCard = paymentOptionSelected as? CustomerPaymentMethod {
            properties[TrackingUtil.METADATA_CARD_ID] = customerCard.customerPaymentMethodId
        }
        if let installments = paymentData.payerCost?.installments {
            properties[TrackingUtil.METADATA_INSTALLMENTS] = installments.stringValue
        }

        MPXTracker.sharedInstance.trackScreen(screenId: screenId, screenName: screenName, properties: properties)
    }
}

// One tap implementations.
extension PXOneTapViewModel {

    func getPaymentMethodComponent(withAction: PXComponentAction?) -> PXPaymentMethodComponent? {

        guard let pm = paymentData.getPaymentMethod() else {
            return nil
        }

        let paymentMethodName = pm.name ?? ""
        let image = PXImageService.getIconImageFor(paymentMethod: pm)
        var title = NSAttributedString(string: "")
        var subtitle: NSAttributedString? = nil
        var cftText: NSAttributedString? = nil
        var noInterestText: NSAttributedString? = nil
        var action = withAction
        let backgroundColor = ThemeManager.shared.whiteColor()
        let lightLabelColor = ThemeManager.shared.labelTintColor()
        let boldLabelColor = ThemeManager.shared.boldLabelTintColor()

        if pm.isCard {
            if let lastFourDigits = (paymentData.token?.lastFourDigits) {
                let text = "\(paymentMethodName) .... \(lastFourDigits)"
                title = text.toAttributedString()
            } else if let card = paymentOptionSelected as? CustomerPaymentMethod {
                if let lastFourDigits = card.getCardLastForDigits() {
                    let text: String = "\(paymentMethodName) .... \(lastFourDigits)"
                    title = text.toAttributedString()
                }
            }
        } else {
            title = paymentMethodName.toAttributedString()
        }

        if let payerCost = paymentData.getPayerCost() {
            // Installments.
            let numberOfInstallments: Int = payerCost.installments
            let installmentAmount: Double = payerCost.installmentAmount
            let currency: Currency = MercadoPagoContext.getCurrency()
            let amountFormatted: String = Utils.getAmountFormatted(amount: installmentAmount, thousandSeparator: currency.getThousandsSeparatorOrDefault(), decimalSeparator: currency.getDecimalSeparatorOrDefault(), addingCurrencySymbol: currency.getCurrencySymbolOrDefault(), addingParenthesis: false)
            let subtitleDisplayText = "\(numberOfInstallments)x \(amountFormatted)"
            subtitle = subtitleDisplayText.toAttributedString()

            // Interest.
            if !payerCost.hasInstallmentsRate() {
                 noInterestText = "Sin interés".localized.toAttributedString()
            }

            // CFT.
            if payerCost.hasCFTValue(), let cftValue = payerCost.getCFTValue() {
                cftText = cftValue.toAttributedString()
            }
        }

        if !self.reviewScreenPreference.isChangeMethodOptionEnabled() {
            action = nil
        }

        let props = PXPaymentMethodProps(paymentMethodIcon: image, title: title, subtitle: subtitle, descriptionTitle: noInterestText, descriptionDetail: cftText, disclaimer: nil, action: action, backgroundColor: backgroundColor, lightLabelColor: lightLabelColor, boldLabelColor: boldLabelColor)
        return PXPaymentMethodComponent(props: props)
    }
}
