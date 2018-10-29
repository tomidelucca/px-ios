//
//  PXOneTapInstallmentInfoViewModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 16/10/18.
//

import Foundation

final class PXOneTapInstallmentInfoViewModel {
    var text: NSAttributedString
    var installmentData: PXInstallment?
    var selectedPayerCost: PXPayerCost?
    var shouldShow: Bool

    init(text: NSAttributedString, installmentData: PXInstallment?, selectedPayerCost: PXPayerCost?, shouldShow: Bool) {
        self.text = text
        self.installmentData = installmentData
        self.selectedPayerCost = selectedPayerCost
        self.shouldShow = shouldShow
    }

    func update(text: NSAttributedString, installmentData: PXInstallment?, selectedPayerCost: PXPayerCost?, shouldShow: Bool) {
        self.text = text
        self.installmentData = installmentData
        self.selectedPayerCost = selectedPayerCost
        self.shouldShow = shouldShow
    }
}
