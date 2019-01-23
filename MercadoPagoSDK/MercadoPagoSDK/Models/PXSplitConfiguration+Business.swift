//
//  PXSplitConfiguration+Business.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 23/01/2019.
//

import Foundation

internal extension PXSplitConfiguration {

    func getSplitAmountToPay() -> Double {
        if let discountAmountOff = secondaryPaymentMethodDiscount?.couponAmount {
            return splitAmount - discountAmountOff
        } else {
            return splitAmount
        }
    }
}
