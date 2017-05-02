//
//  ContentCellViewModelTest.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 4/29/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//
import XCTest
@testable import MercadoPagoSDK
class ContentCellViewModelTest : BaseTest {
    var instance: ContentCellRefactorViewModel!
    var paymentData: PaymentData!
    var paymentResult: PaymentResult!
    var paymentResultPreference = PaymentResultScreenPreference()
    
    override func setUp() {
        super.setUp()
        self.paymentData = MockBuilder.buildPaymentData(paymentMethodId: "visa", installments: 1, installmentRate: 0)
        self.paymentResult = PaymentResult(status: "rejected", statusDetail: "cc_rejected_bad_filled_securityCode", paymentData: paymentData, payerEmail: "sarsa@sarasita.com", id: "123", statementDescription: "mercadopago")
        self.instance = ContentCellRefactorViewModel(paymentResult: paymentResult, paymentResultScreenPreference: paymentResultPreference)
    }
    
    func testStatusDetail(){
        XCTAssertEqual(self.instance.paymentResult.statusDetail, "cc_rejected_bad_filled_other")
        XCTAssertTrue(self.instance.hasStatusDetail())
        
        self.instance.paymentResult.statusDetail = ""
        XCTAssertFalse(self.instance.hasStatusDetail())
    }
    
    func testStastus() {
        self.instance.paymentResult.status = "rejected"
        XCTAssertTrue(self.instance.isPaymentRejected())
        XCTAssertFalse(self.instance.isPaymentPending())
        
        self.instance.paymentResult.status = "in_process"
        XCTAssertTrue(self.instance.isPaymentPending())
        XCTAssertFalse(self.instance.isPaymentRejected())
    }
    
    //*********************
    // Rejected Payments
    //*********************
    
    func testRejectedGetTitle() {
        self.instance.paymentResult.status = "rejected"
        
        // Con statusDetail = "other_reason"
        // ¿Que puede hacer?
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.OTHER_REASON.rawValue
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), self.instance.defaultTitle)
        
        // Con statusDetail = "cc_rejected_call_for_authorize"
        // ¿No pudiste autorizarlo?
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.CALL_FOR_AUTH.rawValue
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), (paymentResult.statusDetail + "_title").localized)
        
        // Con statusDetail = "" y sin PaymentResultScreenPreference
        // ¿Que puedo hacer?
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.rejectedContentTitle = ""
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), self.instance.defaultTitle)
        
        // Con statusDetail = "" y con PaymentResultScreenPreference
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.rejectedContentTitle = "Sarasa"
        
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), "Sarasa")
        
        // Con statusDetail = "other_reason" y con PaymentResultScreenPreference
        // ¿Que puede hacer?
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.OTHER_REASON.rawValue
        self.instance.paymentResultScreenPreference.rejectedContentTitle = "Sarasa"
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), self.instance.defaultTitle)
        
        // Con statusDetail = "other_reason" y titulo deshabilitado
        // ¿Que puede hacer?
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.OTHER_REASON.rawValue
        self.instance.paymentResultScreenPreference.hideRejectedContentTitle = true
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), self.instance.defaultTitle)
        
        // Con statusDetail = "" y titulo deshabilitado
        // No se deberia mostrar titulo
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.hideRejectedContentTitle = true
        XCTAssertFalse(self.instance.hasTitle())
        
    }
    
    func testRejectedGetSubtitle(){
        self.instance.paymentResult.status = "rejected"
        self.instance.paymentResult.paymentData?.paymentMethod.paymentTypeId = "credit_card"
        self.instance.paymentResult.paymentData?.paymentMethod.name = "Visa"
        
        // Con statusDetail = "other_reason"
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.OTHER_REASON.rawValue
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), (self.instance.paymentResult.statusDetail + "_subtitle_" + "credit_card").localized)
        
        // Con statusDetail = "high_risk"
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.HIGH_RISK.rawValue
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), (self.instance.paymentResult.statusDetail + "_subtitle_" + "credit_card").localized)
        
        // Con statusDetail = "max_attemps"
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.MAX_ATTEMPTS.rawValue
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), (self.instance.paymentResult.statusDetail + "_subtitle_" + "credit_card").localized)
        
        // Con statusDetail = "CARD_DISABLE"
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.CARD_DISABLE.rawValue
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), (self.instance.paymentResult.statusDetail + "_subtitle_" + "credit_card").localized)
        
        // Con statusDetail = "BAD_FILLED_OTHER"
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.BAD_FILLED_OTHER.rawValue
        XCTAssertFalse(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "")
        
        // Con statusDetail = "DUPLICATED_PAYMENT"
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.DUPLICATED_PAYMENT.rawValue
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), (self.instance.paymentResult.statusDetail + "_subtitle_" + "credit_card").localized)
        
        // Con statusDetail = "INSUFFICIENT_AMOUNT"
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.INSUFFICIENT_AMOUNT.rawValue
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), (self.instance.paymentResult.statusDetail + "_subtitle_" + "credit_card").localized)
        
        // Con statusDetail = "cc_rejected_call_for_authorize"
        // No hay subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.CALL_FOR_AUTH.rawValue
        XCTAssertFalse(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "")
        
        // Con statusDetail = "" y sin PaymentResultScreenPreference
        // NO se deberia mostrar subtitulo
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.rejectedContentText = ""
        XCTAssertFalse(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "")
        
        // Con statusDetail = "" y con PaymentResultScreenPreference
        // Sarasa
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.rejectedContentText = "Sarasa"
        
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "Sarasa")
        
        // Con statusDetail = "other_reason" y con PaymentResultScreenPreference
        // Se deberia mostrar nuestro subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.OTHER_REASON.rawValue
        self.instance.paymentResultScreenPreference.rejectedContentTitle = "Sarasa"
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), (self.instance.paymentResult.statusDetail + "_subtitle_" + "credit_card").localized)
        
        // Con statusDetail = "other_reason" y subtitulo deshabilitado
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = RejectedStatusDetail.OTHER_REASON.rawValue
        self.instance.paymentResultScreenPreference.hideRejectedContentText = true
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), (self.instance.paymentResult.statusDetail + "_subtitle_" + "credit_card").localized)
        
        // Con statusDetail = "" y titulo deshabilitado
        // No se deberia mostrar subtitulo
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.hideRejectedContentText = true
        XCTAssertFalse(self.instance.hasSubtitle())
    }
    
    //*********************
    // Pending Payments
    //*********************
    
    func testPendingGetTitle() {
        self.instance.paymentResult.status = "in_process"
        
        // Con statusDetail = "CONTINGENCY"
        // ¿Que puede hacer?
        self.instance.paymentResult.statusDetail = PendingStatusDetail.CONTINGENCY.rawValue
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), self.instance.defaultTitle)
        
        // Con statusDetail = "REVIEW_MANUAL"
        // ¿Que puede hacer?
        self.instance.paymentResult.statusDetail = PendingStatusDetail.REVIEW_MANUAL.rawValue
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), self.instance.defaultTitle)
        
        
        // Con statusDetail = "" y sin PaymentResultScreenPreference
        // ¿Que puedo hacer?
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.pendingContentTitle = ""
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), self.instance.defaultTitle)
        
        // Con statusDetail = "" y con PaymentResultScreenPreference
        // Sarasa
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.pendingContentTitle = "Sarasa"
        
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), "Sarasa")
        
        // Con statusDetail = "CONTINGENCY" y con PaymentResultScreenPreference
        // ¿Que puede hacer?
        self.instance.paymentResult.statusDetail = PendingStatusDetail.CONTINGENCY.rawValue
        self.instance.paymentResultScreenPreference.pendingContentTitle = "Sarasa"
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), self.instance.defaultTitle)
        
        // Con statusDetail = "other_reason" y titulo deshabilitado
        // ¿Que puede hacer?
        self.instance.paymentResult.statusDetail = PendingStatusDetail.CONTINGENCY.rawValue
        self.instance.paymentResultScreenPreference.hidePendingContentTitle = true
        XCTAssertTrue(self.instance.hasTitle())
        XCTAssertEqual(self.instance.getTitle(), self.instance.defaultTitle)
        
        // Con statusDetail = "" y titulo deshabilitado
        // No se deberia mostrar titulo
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.hidePendingContentTitle = true
        XCTAssertFalse(self.instance.hasTitle())
        
    }
    
    func testPendingGetSubtitle(){
        self.instance.paymentResult.status = "in_process"
        self.instance.paymentResult.paymentData?.paymentMethod.paymentTypeId = "credit_card"
        self.instance.paymentResult.paymentData?.paymentMethod.name = "Visa"
        
        // Con statusDetail = "CONTINGENCY"
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = PendingStatusDetail.CONTINGENCY.rawValue
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "En menos de 1 hora te enviaremos por e-mail el resultado.".localized)
        
        // Con statusDetail = "REVIEW_MANUAL"
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = PendingStatusDetail.REVIEW_MANUAL.rawValue
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "En menos de 2 días hábiles te diremos por e-mail si se acreditó o si necesitamos más información.".localized)
        
        // Con statusDetail = "" y sin PaymentResultScreenPreference
        // NO se deberia mostrar subtitulo
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.rejectedContentText = ""
        XCTAssertFalse(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "")
        
        // Con statusDetail = "" y con PaymentResultScreenPreference
        // Sarasa
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.pendingContentText = "Sarasa"
        
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "Sarasa")
        
        // Con statusDetail = "other_reason" y con PaymentResultScreenPreference
        // Se deberia mostrar nuestro subtitulo
        self.instance.paymentResult.statusDetail = PendingStatusDetail.CONTINGENCY.rawValue
        self.instance.paymentResultScreenPreference.pendingContentText = "Sarasa"
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "En menos de 1 hora te enviaremos por e-mail el resultado.".localized)
        
        // Con statusDetail = "other_reason" y subtitulo deshabilitado
        // Hay subtitulo
        self.instance.paymentResult.statusDetail = PendingStatusDetail.CONTINGENCY.rawValue
        self.instance.paymentResultScreenPreference.hidePendingContentText = true
        XCTAssertTrue(self.instance.hasSubtitle())
        XCTAssertEqual(self.instance.getSubtitle(), "En menos de 1 hora te enviaremos por e-mail el resultado.".localized)
        
        // Con statusDetail = "" y titulo deshabilitado
        // No se deberia mostrar subtitulo
        self.instance.paymentResult.statusDetail = ""
        self.instance.paymentResultScreenPreference.hidePendingContentText = true
        XCTAssertFalse(self.instance.hasSubtitle())
    }
    
}
