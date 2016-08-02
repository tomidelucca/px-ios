//
//  PaymentInfo.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 29/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class AmountInfo: NSObject {
    
    var amount : Double?
    var currency : Currency?

    override init(){
        super.init()
    }
    
    public class func fromJSON(json : NSDictionary) -> AmountInfo {
        let amountInfo : AmountInfo = AmountInfo()
        
        if json["amount"] != nil && !(json["amount"]! is NSNull) {
            amountInfo.amount = JSON(json["amount"]!).asDouble!
        }
        
        let currency = Currency()
        if json["thousands_separator"] != nil && !(json["thousands_separator"]! is NSNull) {
            let thousandsSeparatorText = (json["thousands_separator"] as! String)
            currency.thousandsSeparator = thousandsSeparatorText[thousandsSeparatorText.startIndex.advancedBy(0)]
        }
        
        if json["decimal_separator"] != nil && !(json["decimal_separator"]! is NSNull) {
            let decimalsSeparatorText = (json["decimal_separator"] as! String)
            currency.decimalSeparator = decimalsSeparatorText[decimalsSeparatorText.startIndex.advancedBy(0)]
        }
        
        if json["symbol"] != nil && !(json["symbol"]! is NSNull) {
            currency.symbol = json["symbol"] as! String
        }
        
        if json["decimal_places"] != nil && !(json["decimal_places"]! is NSNull) {
            currency.decimalPlaces = json["decimal_places"] as! Int
        }
        
        amountInfo.currency = currency
        return amountInfo
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "amount": self.amount!,
            "thousands_separator": self.currency == nil ? JSON.null : String(self.currency!.thousandsSeparator),
            "decimal_separator": self.currency == nil ? JSON.null : String(self.currency!.decimalSeparator),
            "symbol": self.currency == nil ? JSON.null : self.currency!.symbol,
            "decimal_places": self.currency == nil ? JSON.null : self.currency!.decimalPlaces
        ]
        
        return JSON(obj).toString()
    }
    
}
