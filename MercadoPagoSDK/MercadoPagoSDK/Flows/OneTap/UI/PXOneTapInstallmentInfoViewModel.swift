//
//  PXOneTapInstallmentInfoViewModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 16/10/18.
//

import Foundation

final class PXOneTapInstallmentInfoViewModel {
    var leftText: String
    var rightText: String
    var installmentData: PXInstallment?

    init(leftText: String, rightText: String, installmentData: PXInstallment?) {
        self.leftText = leftText
        self.rightText = rightText
        self.installmentData = installmentData
    }

    func update(leftText: String, rightText: String, installmentData: PXInstallment?) {
        self.leftText = leftText
        self.rightText = rightText
        self.installmentData = installmentData
    }
}
