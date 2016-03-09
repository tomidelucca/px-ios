//
//  PaymentVaultViewControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class PaymentVaultViewControllerTest: BaseTest {
    
    var paymentVaultViewController : PaymentVaultViewController?
    
    override func setUp() {
        super.setUp()
        self.paymentVaultViewController = PaymentVaultViewController(amount: 7.5, currencyId: "MXN", purchaseTitle: "Purchase title", excludedPaymentTypes:  MockBuilder.getMockPaymentTypeIds(), excludedPaymentMethods: ["visa"], installments: 1, defaultInstallments: 1, callback: { (paymentMethod, tokenId, issuer, installments) -> Void in
            
        })
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertEqual(paymentVaultViewController!.merchantBaseUrl, MercadoPagoContext.baseURL())
        XCTAssertEqual(paymentVaultViewController!.publicKey, MercadoPagoContext.publicKey())
        XCTAssertEqual(paymentVaultViewController!.merchantAccessToken,  MercadoPagoContext.merchantAccessToken())
        XCTAssertNil(paymentVaultViewController?.paymentMethodsSearch)
        
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        
        XCTAssertNotNil(self.paymentVaultViewController?.paymentMethodsSearch)
        XCTAssertTrue(self.paymentVaultViewController?.paymentMethodsSearch!.count > 1)
        XCTAssertNotNil(self.paymentVaultViewController?.paymentsTable)
        // Verify preference description row
        XCTAssertTrue(self.paymentVaultViewController?.paymentsTable.numberOfRowsInSection(0) == 0)
        // Payments options
        XCTAssertTrue(self.paymentVaultViewController?.paymentsTable.numberOfRowsInSection(1) > 0)
        
        
        
        
    }
    
}
