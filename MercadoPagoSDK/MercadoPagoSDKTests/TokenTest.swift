//
//  TokenTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class TokenTest: BaseTest {
    
    let date = NSDate()
    let modificationDate = NSDate()
    let dueDate = NSDate()
    
    func testInit(){
        let token = Token(_id: "id", publicKey: "publicKey", cardId: "cardId", luhnValidation: "luhn", status: "status", usedDate: "usedDate", cardNumberLength: 12, creationDate: date, truncCardNumber: "truncCardNumber", securityCodeLength: 3, expirationMonth: 1, expirationYear: 20, lastModifiedDate: modificationDate, dueDate: dueDate)
        XCTAssertEqual(token._id, "id")
        XCTAssertEqual(token.publicKey, "publicKey")
        XCTAssertEqual(token.cardId, "cardId")
        XCTAssertEqual(token.luhnValidation, "luhn")
        XCTAssertEqual(token.status, "status")
        XCTAssertEqual(token.usedDate, "usedDate")
        XCTAssertEqual(token.cardNumberLength, 12)
        XCTAssertEqual(token.creationDate, date)
        XCTAssertEqual(token.truncCardNumber, "truncCardNumber")
        XCTAssertEqual(token.securityCodeLength, 3)
        XCTAssertEqual(token.expirationMonth, 1)
        XCTAssertEqual(token.expirationYear, 20)
        XCTAssertEqual(token.lastModifiedDate, modificationDate)
        XCTAssertEqual(token.dueDate, dueDate)
        
    }
    
    func testFromJSON(){
        let json : NSDictionary = MockManager.getMockFor("Token")!
        let tokenCodeFromJSON = Token.fromJSON(json)
        XCTAssertEqual(tokenCodeFromJSON, tokenCodeFromJSON)
    }
}
