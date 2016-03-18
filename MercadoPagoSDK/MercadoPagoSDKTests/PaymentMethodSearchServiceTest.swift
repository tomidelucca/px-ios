//
//  PaymentMethodSearchServiceTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 14/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class PaymentMethodSearchServiceTest: BaseTest {
    
    override func setUp() {
        super.setUp()
        MercadoPagoContext.setPublicKey(MockBuilder.MOCK_PUBLIC_KEY)
    }
    
    func testProperURLS() {
        XCTAssertEqual(PaymentMethodSearchService().MP_SEARCH_BASE_URL, "https://api.mercadopago.com")
        XCTAssertEqual(PaymentMethodSearchService().MP_SEARCH_PAYMENTS_URI, "/checkout/beta/v1/payment_methods/search/options")
    }
    
    
    func testMPServicePaymentMethodSearch() {
        let expectation = expectationWithDescription("paymentMethodSearchService")
        MPServicesBuilder.searchPaymentMethods(nil, excludedPaymentMethods: nil, success: { (PaymentMethodSearch) -> Void in
            expectation.fulfill()
            }) { (error) -> Void in
        }
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testMPServicePaymentMethodSearchWithExcludedPaymentTypes() {
        let expectation = expectationWithDescription("paymentMethodSearchService")
        MPServicesBuilder.searchPaymentMethods(MockBuilder.getMockPaymentTypeIds(), excludedPaymentMethods: nil, success: { (PaymentMethodSearch) -> Void in
            expectation.fulfill()
            }) { (error) -> Void in
        }
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testMPServicePaymentMethodSearchWithPaymentMethodIdsExcluded() {
        let expectation = expectationWithDescription("paymentMethodSearchService")
        MPServicesBuilder.searchPaymentMethods(nil, excludedPaymentMethods: ["amex", "oxxo"], success: { (PaymentMethodSearch) -> Void in
            expectation.fulfill()
            }) { (error) -> Void in
        }
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testMPServicePaymentMethodSearchWithPaymentMethodIdsAndPaymentTypesExcluded() {
        let expectation = expectationWithDescription("paymentMethodSearchService")
        MPServicesBuilder.searchPaymentMethods(MockBuilder.getMockPaymentTypeIds(), excludedPaymentMethods: ["amex", "oxxo"], success: { (PaymentMethodSearch) -> Void in
            expectation.fulfill()
            }) { (error) -> Void in
        }
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    
}
