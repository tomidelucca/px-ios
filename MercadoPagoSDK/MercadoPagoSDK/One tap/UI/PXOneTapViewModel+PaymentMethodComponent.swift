//
//  PXOneTapViewModel+PaymentMethodComponent.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

// One Tap - Payment method component.
extension PXOneTapViewModel {

    func getPaymentMethodComponent() -> PXPaymentMethodComponent? {
        guard let pm = self.amountHelper.paymentData.getPaymentMethod() else {
            return nil
        }

        let paymentMethodName = pm.name ?? ""
        let image = PXImageService.getIconImageFor(paymentMethod: pm)
        var title = NSAttributedString(string: "")
        var subtitle: NSAttributedString? = nil
        var cftText: NSAttributedString? = nil
        var noInterestText: NSAttributedString? = nil
        let backgroundColor = ThemeManager.shared.whiteColor()
        let lightLabelColor = ThemeManager.shared.labelTintColor()
        let boldLabelColor = ThemeManager.shared.boldLabelTintColor()

        if pm.isCard {
            if let lastFourDigits = (self.amountHelper.paymentData.token?.lastFourDigits) {
                let text = "\(paymentMethodName) ···· \(lastFourDigits)"
                title = text.toAttributedString()
            } else if let card = paymentOptionSelected as? CustomerPaymentMethod {
                if let lastFourDigits = card.getCardLastForDigits() {
                    let text: String = "\(paymentMethodName) ···· \(lastFourDigits)"
                    title = text.toAttributedString()
                }
            }
        } else {
            title = paymentMethodName.toAttributedString()
        }

        if let payerCost = self.amountHelper.paymentData.getPayerCost() {
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

        let props = PXPaymentMethodProps(paymentMethodIcon: image, title: title, subtitle: subtitle, descriptionTitle: noInterestText, descriptionDetail: cftText, disclaimer: nil, action: nil, backgroundColor: backgroundColor, lightLabelColor: lightLabelColor, boldLabelColor: boldLabelColor)
        return PXPaymentMethodComponent(props: props)
    }
}
