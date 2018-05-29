//
//  PXDiscount.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 29/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServices

internal extension PXDiscount {
    internal func getDescription() -> String {
        if getDiscountDescription() != "" {
            return getDiscountDescription() + "discount_coupon_detail_description".localized_beta
        } else {
            return ""
        }
    }
    
    internal func getDiscountDescription() -> String {
        let currency = MercadoPagoContext.getCurrency()
        if let percentOff = self.percentOff, percentOff != 0 {
            return String(describing: percentOff) + " %"
        } else if let amountOff = self.amountOff, amountOff != 0 {
            return currency.symbol + String(describing: amountOff)
        } else {
            return ""
        }
    }
    internal func getDiscountAmount() -> Double? {
        if let percentOff = self.percentOff, percentOff != 0 {
            return percentOff // Deberia devolver el monto que se descuenta
        } else if let amountOff = self.amountOff, amountOff != 0 {
            return amountOff
        }
        return nil
    }
    
    internal func getDiscountReviewDescription() -> String {
        let text  = "discount_coupon_detail_default_concept".localized_beta
         if let percentOff = self.percentOff, percentOff != 0 {
            return text + " " + String(describing: percentOff) + " %"
        }
        return text
    }
    internal func concept() -> String {
        return getDiscountReviewDescription()
    }
}
