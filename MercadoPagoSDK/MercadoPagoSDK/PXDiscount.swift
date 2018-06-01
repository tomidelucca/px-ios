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
    override open var description : String {
        get {
            if getDiscountDescription() != "" {
                return getDiscountDescription() + "discount_coupon_detail_description".localized_beta
            } else {
                return ""
            }
        }
    }
    
    internal func getDiscountDescription() -> String {
        let currency = MercadoPagoContext.getCurrency()
        if self.percentOff != 0 {
            return String(describing: self.percentOff) + " %"
        } else if self.amountOff != 0 {
            return currency.symbol + String(describing: self.amountOff)
        } else {
            return ""
        }
    }
    internal func getDiscountAmount() -> Double? {
        return self.couponAmount
    }
    
    internal func getDiscountReviewDescription() -> String {
        let text  = "discount_coupon_detail_default_concept".localized_beta
         if self.percentOff != 0 {
            return text + " " + String(describing: self.percentOff) + " %"
        }
        return text
    }
    var concept : String {
        get {
            return getDiscountReviewDescription()
        }
    }
    
    func toJSONDictionary() -> [String: Any] {
        
        var obj: [String: Any] = [
            "id": self.id,
            "percent_off": self.percentOff ?? 0,
            "amount_off": self.amountOff ??  0,
            "coupon_amount": self.couponAmount ?? 0
        ]
        
        if let name = self.name {
            obj["name"] = name
        }
        
        if let currencyId = self.currencyId {
            obj["currency_id"] = currencyId
        }

        obj["concept"] = self.concept

        if let campaignId = self.id {
            obj["campaign_id"] = campaignId
        }
        
        return obj
    }
}
