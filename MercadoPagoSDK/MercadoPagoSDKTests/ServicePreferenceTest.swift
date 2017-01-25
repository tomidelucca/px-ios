//
//  ServicePreferenceTest.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 1/25/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

class ServicePreferenceTest: BaseTest {
    
    public func testInit(){
        let servicePreference = ServicePreference()
        print(servicePreference.paymentURL.absoluteString)
        print(servicePreference.paymentURL.absoluteURL)
        XCTAssertEqual(servicePreference.paymentURL, NSURL(string: MercadoPago.MP_PAYMENTS_URI, relativeTo: URL(string: MercadoPago.MP_API_BASE_URL))!)
    }
}
