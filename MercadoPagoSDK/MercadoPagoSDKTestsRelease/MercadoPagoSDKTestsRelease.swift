//
//  MercadoPagoSDKTestsRelease.swift
//  MercadoPagoSDKTestsRelease
//
//  Created by Eden Torres on 6/9/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

class MercadoPagoSDKTestsRelease: BaseTest {
    
    func testSDKVersion() {
        XCTAssertEqual(MercadoPagoContext.sharedInstance.sdkVersion(), "2.2.13")
    }

    func testPlatform(){
        XCTAssertEqual(MercadoPagoContext.sharedInstance.framework(), "iOS")
    }

    func testProdEnviroment(){
        XCTAssertEqual(MercadoPago.MP_ENVIROMENT, MercadoPago.MP_PROD_ENV + "/checkout")
        XCTAssertEqual(MercadoPago.MP_API_BASE_URL, MercadoPago.MP_API_BASE_URL_PROD)
    }
    
}
