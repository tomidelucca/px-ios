//
//  ResultViewModelTest.swift
//  MercadoPagoSDKTests
//
//  Created by Demian Tejo on 31/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

class ResultViewModelTest: BaseTest {

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
        XCTAssertEqual(resultViewModel.iconImageHeader(), MercadoPago.getImage("default_item_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(), MercadoPago.getImage("ok_badge"))
        XCTAssertNil(resultViewModel.labelTextHeader())
        XCTAssertEqual(resultViewModel.titleHeader().string, "¡Listo, se acreditó tu pago!".localized)
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
    }

    func testViewModelWithoutPreferenceAndRejectedPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxRedMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(), MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(), MercadoPago.getImage("error_badge"))
        XCTAssertEqual(resultViewModel.labelTextHeader()?.string, "Algo salió mal...".localized)
        XCTAssertEqual(resultViewModel.titleHeader().string, "Uy, no pudimos procesar el pago".localized)
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertTrue(resultViewModel.isError())
    }

    func testViewModelWithoutPreferenceAndPendingPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("in_process", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxGreenMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(), MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(), MercadoPago.getImage("pending_badge"))
        XCTAssertNil(resultViewModel.labelTextHeader())
        XCTAssertEqual(resultViewModel.titleHeader().string, "Estamos procesando el pago".localized)
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
    }

    func testViewModelWithTextPreferenceAndApprovedPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setApproved(title: approvedTitleDummy)
        preference.setApproved(labelText: approvedLabelDummy)
        let paymentResult = MockBuilder.buildPaymentResult("approved", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil, paymentResultScreenPreference:preference)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxGreenMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(), MercadoPago.getImage("default_item_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(), MercadoPago.getImage("ok_badge"))
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(resultViewModel.labelTextHeader()?.string, approvedLabelDummy)
        XCTAssertEqual(resultViewModel.titleHeader().string, approvedTitleDummy)
    }

    func testViewModelWithTextPreferenceAndRejectedPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setRejected(title: rejectedTitleDummy)
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil, paymentResultScreenPreference: preference)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxRedMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(), MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(), MercadoPago.getImage("error_badge"))
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertTrue(resultViewModel.isError())
        XCTAssertEqual(resultViewModel.titleHeader().string, rejectedTitleDummy)
        XCTAssertEqual(resultViewModel.labelTextHeader()?.string, "Algo salió mal...".localized)
    }

    func testViewModelWithTextPreferenceAndPendingPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setPending(title: pendingTitleDummy)
        preference.disablePendingLabelText()
        let paymentResult = MockBuilder.buildPaymentResult("in_process", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil, paymentResultScreenPreference: preference)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxGreenMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(), MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(), MercadoPago.getImage("pending_badge"))
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(resultViewModel.labelTextHeader(), nil)
        XCTAssertEqual(resultViewModel.titleHeader().string, "Estamos procesando el pago".localized)
    }
    
    func testViewModelWithTextPreferenceAndCallForAuth() {
        let preference = PaymentResultScreenPreference()
        preference.setPending(title: pendingTitleDummy)
        preference.disablePendingLabelText()
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        paymentResult.statusDetail = RejectedStatusDetail.CALL_FOR_AUTH
        paymentResult.paymentData?.payerCost = PayerCost(installments: 1, installmentRate: 1, labels: [], minAllowedAmount: 100, maxAllowedAmount: 100, recommendedMessage: "", installmentAmount: 1, totalAmount: 100)
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, instructionsInfo: nil, paymentResultScreenPreference: preference)
        XCTAssertEqual(resultViewModel.primaryResultColor(), UIColor.pxOrangeMp)
        XCTAssertEqual(resultViewModel.iconImageHeader(), MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(resultViewModel.badgeImage(), MercadoPago.getImage("need_action_badge"))
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertTrue(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(resultViewModel.labelTextHeader(), "Algo salió mal...".localized.toAttributedString())
    }
    
    

}
