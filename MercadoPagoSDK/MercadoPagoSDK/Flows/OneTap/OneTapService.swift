//
//  OneTapService.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 16/10/18.
//

import Foundation

struct OneTapService {

    static func getInstallmentsViewModel(amount: Int) -> [PXOneTapInstallmentInfoViewModel] {
        var models: [PXOneTapInstallmentInfoViewModel] = []

        for i in 1...amount {
            let cftRandom = Double.random(in: 1 ... 100)
            let installmentRandom = Int.random(in: 1 ... 12)
            let amountRandom = Double.random(in: 200 ... 1000)
            let payerCost = [
                PXPayerCost(installmentRate: 0, labels: [], minAllowedAmount: 0, maxAllowedAmount: 20000, recommendedMessage: "Sin interes", installmentAmount: 300, totalAmount: 300, installments: 1),
                PXPayerCost(installmentRate: 0, labels: [], minAllowedAmount: 0, maxAllowedAmount: 20000, recommendedMessage: "Sin interes", installmentAmount: 100, totalAmount: 300, installments: 3),
                PXPayerCost(installmentRate: 10, labels: [], minAllowedAmount: 0, maxAllowedAmount: 20000, recommendedMessage: "Sin interes", installmentAmount: 55.55, totalAmount: 330.33, installments: 6)]
            let text: NSMutableAttributedString = NSMutableAttributedString(string: "")
            var mockInstallmentData: PXInstallment? = nil
            if i != 2 {
                let firstAttributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: Utils.getSemiBoldFont(size: PXLayout.XS_FONT), NSAttributedStringKey.foregroundColor: ThemeManager.shared.boldLabelTintColor()]
                let firstText = "\(installmentRandom)x $\(String(format: "%.2f", amountRandom))"
                let firstAttributedString = NSAttributedString(string: firstText, attributes: firstAttributes)

                let secondAttributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XS_FONT), NSAttributedStringKey.foregroundColor: ThemeManager.shared.noTaxAndDiscountLabelTintColor()]
                let secondText = " Sin interés"
                let secondAttributedString = NSAttributedString(string: secondText, attributes: secondAttributes)

                let thirdAttributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XS_FONT), NSAttributedStringKey.foregroundColor: ThemeManager.shared.greyColor()]
                let thirdText = " CFT: \(String(format: "%.2f", cftRandom))%"
                let thirdAttributedString = NSAttributedString(string: thirdText, attributes: thirdAttributes)

                text.append(firstAttributedString)
                text.append(secondAttributedString)
                text.append(thirdAttributedString)

                mockInstallmentData = PXInstallment(issuer: nil, payerCosts: payerCost, paymentMethodId: nil, paymentTypeId: nil)
            }
            let model = PXOneTapInstallmentInfoViewModel(text: text, installmentData: mockInstallmentData)
            models.append(model)
        }
        return models
    }
}
