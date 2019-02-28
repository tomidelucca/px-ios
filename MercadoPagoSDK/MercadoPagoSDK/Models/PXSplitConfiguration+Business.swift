//
//  PXSplitConfiguration+Business.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 23/01/2019.
//

import Foundation

internal extension PXSplitConfiguration {

    func getSplitAmountToPay() -> Double {
        guard let amount = secondaryPaymentMethod?.amount else {
            return 0
        }
        let amountDouble = amount
        if let discountAmountOff = secondaryPaymentMethod?.discount?.couponAmount {
            return amountDouble - discountAmountOff
        } else {
            return amountDouble
        }
    }
}
