//
//  CardTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class CardTest: BaseTest {
    
    var card : Card?
    
    override func setUp() {
        super.setUp()
        self.card = Card()
    }
    
    func testIsSecurityCodeRequired(){
        XCTAssertNil(card!.securityCode, "Security code must be nil")
        XCTAssertFalse(card!.isSecurityCodeRequired())
        
        card!.securityCode = MockBuilder.buildSecurityCode()
        XCTAssertTrue(card!.isSecurityCodeRequired())
    }
}
