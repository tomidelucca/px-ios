//
//  PXAmountHelper.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 29/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServices

internal struct PXAmountHelper {
    
    internal let preference: CheckoutPreference
    internal let paymentData: PaymentData
    internal let discount: PXDiscount?
 //   internal let campaign: PXCampaign

    var preferenceAmount : Double {
        get {
            return self.preference.getAmount()
        }
    }
    
    var amountToPay : Double {
        get {
            if let amountOff = discount?.amountOff {
                return amountWithoutDiscount - amountOff
            } else {
                return amountWithoutDiscount
            }
        }
    }
    
    var amountWithoutDiscount : Double {
        get {
            if let payerCost = paymentData.payerCost {
                return payerCost.totalAmount
            } else {
                return preferenceAmount
            }
        }
    }
    var amountOff : Double {
        get {
            guard let discount = self.discount else {
                return 0
            }
            if let amountOff = discount.amountOff {
                return amountOff
            }
            return 0
        }
    }
    
}
