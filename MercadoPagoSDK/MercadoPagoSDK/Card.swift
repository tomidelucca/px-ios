//
//  Card.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class Card : NSObject, CardInformation {
    
    public var cardHolder : Cardholder?
    public var customerId : String?
    public var dateCreated : NSDate?
    public var dateLastUpdated : NSDate?
    public var expirationMonth : Int = 0
    public var expirationYear : Int = 0
    public var firstSixDigits : String?
    public var idCard : NSNumber = 0
    public var lastFourDigits : String?
    public var paymentMethod : PaymentMethod?
    public var issuer : Issuer?
    public var securityCode : SecurityCode?
    

   public class func fromJSON(json : NSDictionary) -> Card {
        let card : Card = Card()
        if let customerId = JSONHandler.attemptParseToString(json["customer_id"]) {
            card.customerId = customerId
        }
        if let expirationMonth = JSONHandler.attemptParseToInt(json["expiration_month"]) {
            card.expirationMonth = expirationMonth
        }
        if let expirationYear = JSONHandler.attemptParseToInt(json["expiration_year"]) {
            card.expirationYear = expirationYear
        }
        if let idCard = JSONHandler.attemptParseToString(json["id"])?.numberValue {
            card.idCard = idCard
        }
        if let lastFourDigits = JSONHandler.attemptParseToString(json["last_four_digits"]) {
            card.lastFourDigits = lastFourDigits
        }
        if let firstSixDigits = JSONHandler.attemptParseToString(json["first_six_digits"]) {
            card.firstSixDigits = firstSixDigits
        }
        if let issuerDic = json["issuer"] as? NSDictionary {
            card.issuer = Issuer.fromJSON(issuerDic)
        }
        if let secDic = json["security_code"] as? NSDictionary {
            card.securityCode = SecurityCode.fromJSON(secDic)
        }
        if let pmDic = json["payment_method"] as? NSDictionary {
            card.paymentMethod = PaymentMethod.fromJSON(pmDic)
        }
        if let chDic = json["cardholder"] as? NSDictionary {
            card.cardHolder = Cardholder.fromJSON(chDic)
        }
        if let dateLastUpdated = JSONHandler.attemptParseToString(json["date_last_updated"]) {
            card.dateLastUpdated = Utils.getDateFromString(dateLastUpdated)
        }
        if let dateCreated = JSONHandler.attemptParseToString(json["date_created"]) {
            card.dateCreated = Utils.getDateFromString(dateCreated)
        }
        return card
    }
    public func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }
    
    public func toJSON() -> [String:Any]  {
        let cardHolder : Any = self.cardHolder == nil ? JSONHandler.null : self.cardHolder!.toJSON()
        let customer_id : Any = self.customerId == nil ? JSONHandler.null : self.customerId!
        let dateCreated : Any = self.dateCreated == nil ? JSONHandler.null : String(self.dateCreated!)
        let dateLastUpdated : Any = self.dateLastUpdated == nil ? JSONHandler.null : String(self.dateLastUpdated!)
        let firstSixDigits : Any = self.firstSixDigits == nil ? JSONHandler.null : self.firstSixDigits!
        let lastFourDigits : Any = self.lastFourDigits == nil ? JSONHandler.null : self.lastFourDigits!
        let paymentMethod : Any = self.paymentMethod == nil ? JSONHandler.null : self.paymentMethod!.toJSON()
        let issuer : Any = self.issuer == nil ? JSONHandler.null : self.issuer!.toJSONString()
        let obj:[String:Any] = [
            "cardHolder" : cardHolder,
            "customer_id": customer_id,
            "dateCreated" : dateCreated,
            "dateLastUpdated" : dateLastUpdated,
            "expirationMonth" : self.expirationMonth,
            "expirationYear" : self.expirationYear,
            "firstSixDigits" : firstSixDigits,
            "idCard" : self.idCard,
            "lastFourDigits" : lastFourDigits,
            "paymentMethod" : paymentMethod,
            "issuer" : issuer,
            "securityCode" : securityCode  ]
        return obj
    }
    
    public func isSecurityCodeRequired() -> Bool {
        if securityCode != nil {
            if securityCode!.length != 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    
    public func getCardDescription() -> String {
        return "terminada en " + lastFourDigits! //TODO: Make it localizable
    }
    
    public func getPaymentMethod() -> PaymentMethod {
        return self.paymentMethod!
    }
    
    public func getCardId() -> String {
        return self.idCard.stringValue
    }
    
    public func getPaymentMethodId() -> String {
        return (self.paymentMethod?._id)!
    }
    
    public func getCardSecurityCode() -> SecurityCode {
        return self.securityCode!
    }
    
    public func getCardBin() -> String? {
        return self.firstSixDigits
    }

    public func getCardLastForDigits() -> String? {
        return self.lastFourDigits
    }
    
    public func setupPaymentMethodSettings(settings: [Setting]) {
        self.paymentMethod?.settings = settings
    }
}



public func ==(obj1: Card, obj2: Card) -> Bool {
    
    let areEqual =
        obj1.cardHolder == obj2.cardHolder &&
        obj1.customerId == obj2.customerId &&
        obj1.dateCreated == obj2.dateCreated &&
        obj1.dateLastUpdated == obj2.dateLastUpdated &&
        obj1.expirationMonth == obj2.expirationMonth &&
        obj1.firstSixDigits == obj2.firstSixDigits &&
        obj1.idCard == obj2.idCard &&
        obj1.lastFourDigits == obj2.lastFourDigits &&
        obj1.paymentMethod == obj2.paymentMethod &&
        obj1.issuer == obj2.issuer &&
        obj1.securityCode == obj2.securityCode
    return areEqual
}

