//
//  PreferencePaymentMethodsTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class PreferencePaymentMethodsTest: BaseTest {
    
    let paymentmethodIds = ["amex", "oxxo"]
    
    func testInit(){
        let preferencePaymentMethods = PreferencePaymentMethods(excludedPaymentMethods: paymentmethodIds, excludedPaymentTypes: MockBuilder.getMockPaymentTypeIds(), defaultPaymentMethodId: "visa", installments: 12, defaultInstallments: 1)
        XCTAssertEqual(preferencePaymentMethods.excludedPaymentMethods!, paymentmethodIds)
        XCTAssertEqual(preferencePaymentMethods.excludedPaymentTypes, MockBuilder.getMockPaymentTypeIds())
        XCTAssertEqual(preferencePaymentMethods.defaultPaymentMethodId, "visa")
        XCTAssertEqual(preferencePaymentMethods.installments, 12)
        XCTAssertEqual(preferencePaymentMethods.defaultInstallments, 1)
    
    }

}
