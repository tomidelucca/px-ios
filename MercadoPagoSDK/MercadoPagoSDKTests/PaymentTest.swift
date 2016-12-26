//
//  PaymentTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class PaymentTest: BaseTest {
    
    
    func testFromJSON(){
        let json : NSDictionary = MockManager.getMockFor("Payment")!
        let paymentFromJSON = Payment.fromJSON(json)
        XCTAssertEqual(paymentFromJSON, paymentFromJSON)
    }
    
}
