//
//  PayerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class PayerTest: BaseTest {
    
    let identification = MockBuilder.buildIdentification()
    
    func testInit(){
        let payer = Payer(_id: 1, email: "email", type: "type", identification: identification)
        XCTAssertEqual(payer._id, 1)
        XCTAssertEqual(payer.email, "email")
        XCTAssertEqual(payer.type, "type")
        XCTAssertEqual(payer.identification, identification)
    }
    
}
