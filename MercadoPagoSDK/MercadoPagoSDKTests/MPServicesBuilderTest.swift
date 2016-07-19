//
//  MPServicesBuilderTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 8/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class MPServicesBuilderTest: BaseTest {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultUris() {
        XCTAssertEqual(MercadoPago.MP_API_BASE_URL, "https://api.mercadopago.com")
        XCTAssertEqual(MercadoPago.MP_PAYMENTS_URI, "/v1/payments")
    }
    
    
}
