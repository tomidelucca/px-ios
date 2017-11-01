//
//  ResultViewModelTest.swift
//  MercadoPagoSDKTests
//
//  Created by Demian Tejo on 31/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

class ResultViewModelTest: XCTestCase {
    
    let approvedTitleDummy = "ATD"
    let rejectedTitleDummy = "RTD"
    let pendingTitleDummy = "PTD"
    let approvedLabelDummy = "ALD"

    
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
        XCTAssertNil(resultViewModel.labelTextHeader())
        XCTAssertEqual(resultViewModel.titleHeader(), "¡Listo, se acreditó tu pago!".localized)
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
        XCTAssertEqual(resultViewModel.labelTextHeader(),"Algo salió mal...".localized)
        XCTAssertEqual(resultViewModel.titleHeader(), "Uy, no pudimos procesar el pago".localized)
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
        XCTAssertNil(resultViewModel.labelTextHeader())
        XCTAssertEqual(resultViewModel.titleHeader(), "Estamos procesando el pago".localized)
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
    }
    
    func testViewModelWithTextPreferenceAndApprovedPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setApproved(title: approvedTitleDummy)
        preference.setApproved(labelText: approvedLabelDummy)
        let paymentResult = MockBuilder.buildPaymentResult("approved", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil, preference:preference)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxGreenMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(),MercadoPago.getImage("default_item_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(),MercadoPago.getImage("ok_badge"))
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(resultViewModel.labelTextHeader(),approvedLabelDummy)
        XCTAssertEqual(resultViewModel.titleHeader(), approvedTitleDummy)
    }
    
    func testViewModelWithTextPreferenceAndRejectedPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setRejected(title: rejectedTitleDummy)
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil,preference: preference)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxRedMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(),MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(),MercadoPago.getImage("error_badge"))
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertTrue(resultViewModel.isError())
        XCTAssertEqual(resultViewModel.titleHeader(),rejectedTitleDummy)
        XCTAssertEqual(resultViewModel.labelTextHeader(),"Algo salió mal...".localized)
    }
    
    func testViewModelWithTextPreferenceAndPendingPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setPending(title: pendingTitleDummy)
        preference.disablePendingLabelText()
        let paymentResult = MockBuilder.buildPaymentResult("in_process", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil, preference: preference)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxGreenMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(),MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(),MercadoPago.getImage("pending_badge"))
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(resultViewModel.labelTextHeader(),nil)
        XCTAssertEqual(resultViewModel.titleHeader(), "Estamos procesando el pago".localized)

    }

}
