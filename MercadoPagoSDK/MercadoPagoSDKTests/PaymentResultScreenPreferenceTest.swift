//
//  PaymentResultScreenPreferenceTest.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/23/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

class PaymentResultScreenPreferenceTest: BaseTest {
    
    let paymentResultScreenPreference = PaymentResultScreenPreference()
    
    func testSetTitle() {
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getApprovedTitle(), "¡Listo, se acreditó tu pago!".localized)
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getPendingTitle(), "Estamos procesando el pago".localized)
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getRejectedTitle(), "Uy, no pudimos procesar el pago".localized)
        
        paymentResultScreenPreference.setApprovedTitle(title: "1")
        paymentResultScreenPreference.setPendingTitle(title: "2")
        paymentResultScreenPreference.setRejectedTitle(title: "3")
        
        MercadoPagoCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)
        
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getApprovedTitle(), "1")
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getPendingTitle(), "2")
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getRejectedTitle(), "3")
    }
    
    func testSetSubtitle() {
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getApprovedSubtitle(), "")
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getPendingSubtitle(), "")
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getRejectedSubtitle(), "")
        
        paymentResultScreenPreference.setApprovedSubtitle(subtitle: "1")
        paymentResultScreenPreference.setPendingSubtitle(subtitle: "2")
        paymentResultScreenPreference.setRejectedSubtitle(subtitle: "3")
        
        MercadoPagoCheckout.setPaymentResultScreenPreference(paymentResultScreenPreference)
        
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getApprovedSubtitle(), "1")
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getPendingSubtitle(), "2")
        XCTAssertEqual(MercadoPagoCheckoutViewModel.paymentResultScreenPreference.getRejectedSubtitle(), "3")
    }
}
