//
//  Token.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Token : NSObject {
	public var _id : String!
	public var publicKey : String!
	public var cardId : String!
	public var luhnValidation : String!
	public var status : String!
	public var usedDate : String!
	public var cardNumberLength : Int = 0
	public var creationDate : NSDate!
	public var lastFourDigits : String!
    public var firstSixDigit : String!
	public var securityCodeLength : Int = 0
	public var expirationMonth : Int = 0
	public var expirationYear : Int = 0
	public var lastModifiedDate : NSDate!
	public var dueDate : NSDate!
	
    public var cardHolder : Cardholder?
    
    
	public init (_id: String, publicKey: String, cardId: String!, luhnValidation: String!, status: String!,
        usedDate: String!, cardNumberLength: Int, creationDate: NSDate!,lastFourDigits : String!,firstSixDigit : String!,
		securityCodeLength: Int, expirationMonth: Int, expirationYear: Int, lastModifiedDate: NSDate!,
        dueDate: NSDate?, cardHolder : Cardholder?) {
			self._id = _id
			self.publicKey = publicKey
			self.cardId = cardId
			self.luhnValidation = luhnValidation
			self.status = status
			self.usedDate = usedDate
			self.cardNumberLength = cardNumberLength
			self.creationDate = creationDate
			self.lastFourDigits = lastFourDigits
            self.firstSixDigit = firstSixDigit
			self.securityCodeLength = securityCodeLength
			self.expirationMonth = expirationMonth
			self.expirationYear = expirationYear
			self.lastModifiedDate = lastModifiedDate
			self.dueDate = dueDate
            self.cardHolder = cardHolder
	}
    
    public func getBin() -> String? {
        var bin :String? = nil
        if firstSixDigit != nil && firstSixDigit.characters.count > 0 {
            let range = firstSixDigit!.startIndex ..< firstSixDigit!.characters.startIndex.advancedBy(6)
            bin = firstSixDigit!.characters.count >= 6 ? firstSixDigit!.substringWithRange(range) : nil
        }
        
        return bin
    }
      
	
	public class func fromJSON(json : NSDictionary) -> Token {
        
        let _id = JSONHandler.attemptParseToString(json["id"])
        let publicKey = JSONHandler.attemptParseToString(json["public_key"])
		let cardId =  JSONHandler.attemptParseToString(json["card_id"])
		let status = JSONHandler.attemptParseToString(json["status"])
		let luhn = JSONHandler.attemptParseToString(json["luhn_validation"],defaultReturn: "")
		let usedDate = JSONHandler.attemptParseToString(json["date_used"],defaultReturn: "")
		let cardNumberLength = JSONHandler.attemptParseToInt(json["date_used"],defaultReturn: 0)
        
		
		let lastFourDigits = JSONHandler.attemptParseToString(json["last_four_digits"],defaultReturn: "")
        let firstSixDigits = JSONHandler.attemptParseToString(json["first_six_digits"],defaultReturn: "")
		let securityCodeLength = JSONHandler.attemptParseToInt(json["security_code_length"],defaultReturn: 0)
        let expMonth = JSONHandler.attemptParseToInt(json["expiration_month"],defaultReturn: 0)
		let expYear = JSONHandler.attemptParseToInt(json["expiration_year"],defaultReturn: 0)
        
        var cardHolder : Cardholder? = nil
        if let dic = json["cardholder"] as? NSDictionary {
            cardHolder = Cardholder.fromJSON(dic)
        }

		let lastModifiedDate = json.isKeyValid("date_last_updated") ? Utils.getDateFromString(json["date_last_updated"] as? String) : NSDate()
		let dueDate = json.isKeyValid("date_due") ? Utils.getDateFromString(json["date_due"] as? String) : NSDate()
        let creationDate = json.isKeyValid("date_created") ? Utils.getDateFromString(json["date_created"] as? String) : NSDate()
        
        
		return Token(_id: _id!, publicKey: publicKey!, cardId: cardId, luhnValidation: luhn, status: status,
			usedDate: usedDate, cardNumberLength: cardNumberLength!, creationDate: creationDate, lastFourDigits : lastFourDigits, firstSixDigit : firstSixDigits,
			securityCodeLength: securityCodeLength!, expirationMonth: expMonth!, expirationYear: expYear!, lastModifiedDate: lastModifiedDate,
            dueDate: dueDate, cardHolder: cardHolder)
	}
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "_id": self._id != nil ? JSON.null : self._id!,
            "cardId" : self.cardId == nil ? JSON.null : self.cardId!,
            "luhnValidation" : self.luhnValidation == nil ? JSON.null : self.luhnValidation!,
            "status" : self.status,
            "usedDate" : self.usedDate,
            "cardNumberLength" : self.cardNumberLength,
            "creationDate" : Utils.getStringFromDate(self.creationDate),
            "lastFourDigits" : self.lastFourDigits == nil ? JSON.null : self.lastFourDigits,
            "firstSixDigit" : self.firstSixDigit == nil ? JSON.null : self.firstSixDigit,
            "securityCodeLength" : self.securityCodeLength,
            "expirationMonth" : self.expirationMonth,
            "expirationYear" : self.expirationYear,
            "lastModifiedDate" : Utils.getStringFromDate(self.lastModifiedDate),
            "dueDate" : Utils.getStringFromDate(self.dueDate)
        ]

        return JSONHandler.jsonCoding(obj)
    }
    
    public func getCardExpirationDateFormated() -> String {
        return (String(expirationMonth) + String(expirationYear))
    }
    public func getMaskNumber() -> String {
        
        var masknumber : String = ""
    
        for _ in 0...cardNumberLength-4 {
           masknumber = masknumber + "X"
        }
        
           masknumber = masknumber + lastFourDigits
        return masknumber
        
    }
    public func getExpirationDateFormated() -> String {
        
        if self.expirationYear > 0 && self.expirationMonth > 0 {
            return String(self.expirationMonth) + "/" + String(self.expirationYear).substringFromIndex(String(self.expirationYear).endIndex.predecessor().predecessor())
        }
        return ""
    }
}


extension NSDictionary {
	public func isKeyValid(dictKey : String) -> Bool {
		let dictValue: AnyObject? = self[dictKey]
		return (dictValue == nil || dictValue is NSNull) ? false : true
	}
}





public func ==(obj1: Token, obj2: Token) -> Bool {
    
    let areEqual =
    obj1._id == obj2._id &&
    obj1.publicKey == obj2.publicKey &&
    obj1.cardId == obj2.cardId &&
    obj1.luhnValidation == obj2.luhnValidation &&
    obj1.status == obj2.status &&
    obj1.usedDate == obj2.usedDate &&
   // obj1.cardNumberLength == obj2.cardNumberLength &&
  //  obj1.creationDate == obj2.creationDate &&
    obj1.firstSixDigit == obj2.firstSixDigit &&
    obj1.lastFourDigits == obj2.lastFourDigits &&
    obj1.securityCodeLength == obj2.securityCodeLength &&
    obj1.expirationMonth == obj2.expirationMonth &&
    obj1.expirationYear == obj2.expirationYear &&
    obj1.lastModifiedDate == obj2.lastModifiedDate// &&
  //  obj1.dueDate == obj2.dueDate
    
    return areEqual
}

