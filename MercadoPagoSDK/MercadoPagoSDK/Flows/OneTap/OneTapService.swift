//
//  OneTapService.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 16/10/18.
//

import Foundation

struct OneTapService {

    // TODO: Input as DTO models. Output [PXCardSliderViewModel]
    static func getCardSliderViewModel() -> [PXCardSliderViewModel] {
        var mockedViewModel: [PXCardSliderViewModel] = []

        let amCardData = PXCardDataFactory().create(cardName: "Total en tu cuenta: $ 5.643", cardNumber: "", cardCode: "", cardExpiration: "")
        mockedViewModel.append(PXCardSliderViewModel(AccountMoneyCard(), amCardData))

        let masterData = PXCardDataFactory().create(cardName: "JUAN SANZONE", cardNumber: "4356", cardCode: "", cardExpiration: "10/23")
        mockedViewModel.append(PXCardSliderViewModel(Master(), masterData))

        let visaData = PXCardDataFactory().create(cardName: "EDÉN TORRES", cardNumber: "7654", cardCode: "", cardExpiration: "01/21")
        mockedViewModel.append(PXCardSliderViewModel(Visa(), visaData))

        let amexData = PXCardDataFactory().create(cardName: "AUGUSTO C.", cardNumber: "6743", cardCode: "", cardExpiration: "08/25")
        mockedViewModel.append(PXCardSliderViewModel(Amex(), amexData))

        let maestroData = PXCardDataFactory().create(cardName: "DEMIAN TEJO", cardNumber: "4356", cardCode: "", cardExpiration: "10/23")
        mockedViewModel.append(PXCardSliderViewModel(Maestro(), maestroData))

        let galiciaAmexData = PXCardDataFactory().create(cardName: "ESTEBAN QUITO", cardNumber: "6743", cardCode: "", cardExpiration: "08/25")
        mockedViewModel.append(PXCardSliderViewModel(GaliciaAmex(), galiciaAmexData))

        mockedViewModel.append(PXCardSliderViewModel(EmptyCard(), nil))
        return mockedViewModel
    }

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
            var leftText: String = ""
            var rightText: String = ""
            var mockInstallmentData: PXInstallment? = nil
            if i != 2 {
                leftText = "\(installmentRandom)x $\(String(format: "%.2f", amountRandom))"
                rightText = "CFT: \(String(format: "%.2f", cftRandom))%"
                mockInstallmentData = PXInstallment(issuer: nil, payerCosts: payerCost, paymentMethodId: nil, paymentTypeId: nil)
            }
            let model = PXOneTapInstallmentInfoViewModel(leftText: leftText, rightText: rightText, installmentData: mockInstallmentData)
            models.append(model)
        }
        return models
    }
}
