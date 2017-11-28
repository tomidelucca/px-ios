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
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, amount:1000.0, instructionsInfo: nil)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxGreenMp)
        XCTAssertNil(footerView.principalButton)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Seguir comprando".localized)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("default_item_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("ok_badge"))
        XCTAssertNil(headerView.statusLabel?.attributedText)
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, "¡Listo, se acreditó tu pago!".localized)
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
    }

    func testViewModelWithoutPreferenceAndRejectedPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertEqual(footerView.principalButton?.title(for: .normal), "Pagar con otro medio".localized)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Cancelar pago".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxRedMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("error_badge"))
        XCTAssertEqual(headerView.statusLabel?.attributedText?.string, "Algo salió mal...".localized)
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertTrue(resultViewModel.isError())
    }

    func testViewModelWithoutPreferenceAndPendingPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("in_process", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertNil(footerView.principalButton)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Seguir comprando".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxGreenMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("pending_badge"))
        XCTAssertNil(headerView.statusLabel?.attributedText)
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, "Estamos procesando el pago".localized)
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
    }

    func testViewModelWithTextPreferenceAndApprovedPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setApproved(title: approvedTitleDummy)
        preference.setApproved(labelText: approvedLabelDummy)
        let paymentResult = MockBuilder.buildPaymentResult("approved", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil, paymentResultScreenPreference:preference)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertNil(footerView.principalButton)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Seguir comprando".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxGreenMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("default_item_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("ok_badge"))
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(headerView.statusLabel?.attributedText?.string, approvedLabelDummy)
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, approvedTitleDummy)
    }

    func testViewModelWithTextPreferenceAndRejectedPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setRejected(title: rejectedTitleDummy)
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil, paymentResultScreenPreference: preference)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertEqual(footerView.principalButton?.title(for: .normal), "Pagar con otro medio".localized)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Cancelar pago".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxRedMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("error_badge"))
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertTrue(resultViewModel.isError())
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, rejectedTitleDummy)
        XCTAssertEqual(headerView.statusLabel?.attributedText?.string, "Algo salió mal...".localized)
    }

    func testViewModelWithTextPreferenceAndPendingPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setPending(title: pendingTitleDummy)
        preference.disablePendingLabelText()
        let paymentResult = MockBuilder.buildPaymentResult("in_process", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil, paymentResultScreenPreference: preference)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertNil(footerView.principalButton)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Seguir comprando".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxGreenMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("pending_badge"))
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(headerView.statusLabel?.attributedText, nil)
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, "Estamos procesando el pago".localized)
    }

    func testViewModelWithTextPreferenceAndCallForAuth() {
        let preference = PaymentResultScreenPreference()
        preference.setPending(title: pendingTitleDummy)
        preference.disablePendingLabelText()
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        paymentResult.statusDetail = RejectedStatusDetail.CALL_FOR_AUTH
        paymentResult.paymentData?.payerCost = PayerCost(installments: 1, installmentRate: 1, labels: [], minAllowedAmount: 100, maxAllowedAmount: 100, recommendedMessage: "", installmentAmount: 1, totalAmount: 100)
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil, paymentResultScreenPreference: preference)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertEqual(footerView.principalButton?.title(for: .normal), "Pagar con otro medio".localized)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Cancelar pago".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxOrangeMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("need_action_badge"))
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertTrue(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(headerView.statusLabel?.attributedText?.string, "Algo salió mal...".localized.toAttributedString().string)
    }

    func buildHeaderView(resultViewModel: PXResultViewModel) -> HeaderView {
        let data = HeaderProps(labelText: resultViewModel.labelTextHeader(), title: resultViewModel.titleHeader(), backgroundColor: resultViewModel.primaryResultColor(), productImage: resultViewModel.iconImageHeader(), statusImage: resultViewModel.badgeImage())
        let headerComponent = HeaderComponent(props: data)
        return HeaderRenderer().render(header: headerComponent)
    }
    func buildFooterView(resultViewModel: PXResultViewModel) -> FooterView {
        let data = FooterProps(buttonAction: resultViewModel.getActionButton(), linkAction: resultViewModel.getActionLink())
        let footerComponent = FooterComponent(props: data)
        return FooterRenderer().render(footer: footerComponent)
    }

}
