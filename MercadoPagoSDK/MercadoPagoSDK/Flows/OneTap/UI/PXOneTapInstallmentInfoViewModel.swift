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

    init(text: NSAttributedString, installmentData: PXInstallment?) {
        self.text = text
        self.installmentData = installmentData
    }

    func update(text: NSAttributedString, installmentData: PXInstallment?) {
        self.text = text
        self.installmentData = installmentData
    }
}
