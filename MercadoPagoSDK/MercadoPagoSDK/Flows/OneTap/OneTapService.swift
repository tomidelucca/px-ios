//
//  OneTapService.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 16/10/18.
//

import Foundation

struct OneTapService {
    static func getInstallmentViewModel(cardSliderViewModel: PXCardSliderViewModel) -> PXOneTapInstallmentInfoViewModel {
        if cardSliderViewModel.cardData == nil {
            return PXOneTapInstallmentInfoViewModel(leftText: "", rightText: "", installmentData: nil)
        } else {
            // TODO: Get real installments info for each PaymentMethod.
            if cardSliderViewModel.cardUI is AccountMoneyCard {
                return PXOneTapInstallmentInfoViewModel(leftText: "", rightText: "", installmentData: nil)
            } else {
                let cftRandom = Double.random(in: 1 ... 100)
                let installmentRandom = Int.random(in: 1 ... 12)
                let amountRandom = Double.random(in: 200 ... 1000)
                let payerCost = [
                    PXPayerCost(installmentRate: 0, labels: [], minAllowedAmount: 0, maxAllowedAmount: 20000, recommendedMessage: "Sin interes", installmentAmount: 300, totalAmount: 300, installments: 1),
                    PXPayerCost(installmentRate: 0, labels: [], minAllowedAmount: 0, maxAllowedAmount: 20000, recommendedMessage: "Sin interes", installmentAmount: 100, totalAmount: 300, installments: 3),
                    PXPayerCost(installmentRate: 10, labels: [], minAllowedAmount: 0, maxAllowedAmount: 20000, recommendedMessage: "Sin interes", installmentAmount: 55.55, totalAmount: 330.33, installments: 6)]
                let mockInstallmentData = PXInstallment(issuer: nil, payerCosts: payerCost, paymentMethodId: nil, paymentTypeId: nil)
                return PXOneTapInstallmentInfoViewModel(leftText: "\(installmentRandom)x $\(String(format: "%.2f", amountRandom))", rightText: "CFT: \(String(format: "%.2f", cftRandom))%", installmentData: mockInstallmentData)
            }
        }
    }
}
