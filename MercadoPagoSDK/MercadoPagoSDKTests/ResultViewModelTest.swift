//
//  ResultViewModelTest.swift
//  MercadoPagoSDKTests
//
//  Created by Demian Tejo on 31/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

/*
 static let APPROVED = "approved"
 static let REJECTED = "rejected"
 static let RECOVERY = "recovery"
 static let IN_PROCESS = "in_process"
 static let PENDING = "pending"
 */
class ResultViewModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewModelWithoutPreferenceAndApprovedPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("approved", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxGreenMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(),MercadoPago.getImage("default_item_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(),MercadoPago.getImage("ok_badge"))
        XCTAssertNil(resultViewModel.statusMessage())
        XCTAssertEqual(resultViewModel.message(), "¡Listo, se acreditó tu pago!".localized)
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
    }
    
    func testViewModelWithoutPreferenceAndRejectedPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxRedMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(),MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(),MercadoPago.getImage("error_badge"))
        XCTAssertEqual(resultViewModel.statusMessage(),"Algo salió mal...".localized)
        XCTAssertEqual(resultViewModel.message(), "Uy, no pudimos procesar el pago".localized)
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertTrue(resultViewModel.isError())
    }
    
    func testViewModelWithoutPreferenceAndPendingPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("in_process", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxGreenMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(),MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(),MercadoPago.getImage("pending_badge"))
        XCTAssertNil(resultViewModel.statusMessage())
        XCTAssertEqual(resultViewModel.message(), "Estamos procesando el pago".localized)
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
    }
    
    
    func testViewModelWithTextPreference() {
    }
    
    func testViewModelWithLabelText() {
    }

}
