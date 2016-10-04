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
        if let amount = JSONHandler.attemptParseToDouble(json["amount"]) {
            amountInfo.amount = amount
        }
        let currency = Currency()
        if let thousandsSeparator = JSONHandler.attemptParseToString(json["thousands_separator"]) {
            currency.thousandsSeparator = thousandsSeparator
        }
        if let decimalSeparator = JSONHandler.attemptParseToString(json["decimal_separator"]) {
            currency.decimalSeparator = decimalSeparator
        }
        if let symbol = JSONHandler.attemptParseToString(json["symbol"]) {
            currency.symbol = symbol
        }
        if let decimalPlaces = JSONHandler.attemptParseToInt(json["decimal_places"]) {
            currency.decimalPlaces = decimalPlaces
        }
        amountInfo.currency = currency
        return amountInfo
    }
    
    public func toJSONString() -> String {
       return JSONHandler.jsonCoding(self.toJSON())
    }
    
    public func toJSON() -> [String:AnyObject] {
        let obj:[String:AnyObject] = ["amount": self.amount!,
            "thousands_separator": self.currency == nil ? JSON.null : String(self.currency!.thousandsSeparator),
            "decimal_separator": self.currency == nil ? JSON.null : String(self.currency!.decimalSeparator),
            "symbol": self.currency == nil ? JSON.null : self.currency!.symbol,
            "decimal_places": self.currency == nil ? JSON.null : self.currency!.decimalPlaces]
        return obj
    }
    
    
}
