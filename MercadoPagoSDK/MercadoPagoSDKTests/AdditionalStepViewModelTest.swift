//
//  AdditionalStepViewModel.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 4/24/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDK

class PayerCostAdditionalStepViewModelTest : BaseTest {
    var instance: PayerCostAdditionalStepViewModel!
    
    override func setUp() {
        super.setUp()
        let payerCosts = MockBuilder.buildInstallment().payerCosts
        let cardToken = MockBuilder.buildCardToken()
        let paymentMethod = MockBuilder.buildPaymentMethod("visa")
        self.instance = PayerCostAdditionalStepViewModel(amount: 20.0, token: cardToken, paymentMethods: [paymentMethod], dataSource: payerCosts!, discount: nil, email: nil)
    }
    
    func testTitle(){
        XCTAssertEqual(self.instance!.getTitle(), "¿En cuántas cuotas?".localized)
        XCTAssertEqual(self.instance!.maxFontSize, 24)
    }
    
    func testScreenName() {
        XCTAssertEqual(self.instance!.getScreenName(), "PAYER_COST")
    }
    
    func testNumberOfSections() {
        XCTAssertEqual(self.instance!.numberOfSections(), 4)
    }
    func testCardSectionView() {
        XCTAssertTrue(self.instance.getCardSectionView() is CardFrontView)
    }
    
    
    func testRowsWithDiscount() {
        /// Screen:
        /// ¿ En cuantas Cuotas?
        /// (Tarjeta)
        /// (Descuento)
        /// (Cuotas)
        
        let flowPreference = FlowPreference()
        MercadoPagoCheckout.setFlowPreference(flowPreference)
        
        // Title
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 0), 1)
        // Card
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 1), 1)
        // Discount
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 2), 1)
        // Payer Costs
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 3), self.instance!.numberOfCellsInBody())
        
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 6), 0)
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 6)), 0)
        
        
        // Title Cell
        XCTAssertTrue(self.instance!.isTitleCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), 40)
        
        // Card Cell
        XCTAssertTrue(self.instance!.isCardCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 1)), UIScreen.main.bounds.width * 0.50)
        XCTAssertTrue(self.instance!.showCardSection())
        XCTAssertFalse(self.instance!.isBankInterestCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 1, section: 1)), 0)
        
        // Discount Cell
        XCTAssertTrue(self.instance!.showAmountDetailRow())
        XCTAssertTrue(self.instance!.showDiscountSection())
        XCTAssertTrue(self.instance!.isDiscountCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), DiscountBodyCell.HEIGHT)
        
        // Payer Costs
        XCTAssertTrue(self.instance!.showPayerCostDescription())
        XCTAssertTrue(self.instance!.isBodyCellFor(indexPath: IndexPath(row: 0, section: 3)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 3)), 60)
    }
    
    func testRowsWithDiscountAndBankInterest() {
        /// Screen:
        /// ¿ En cuantas Cuotas?
        /// (Tarjeta)
        /// (Intereses Bancarios)
        /// (Descuento)
        /// (Cuotas)
        
        let flowPreference = FlowPreference()
        MercadoPagoCheckout.setFlowPreference(flowPreference)
        
        MercadoPagoContext.setSite(MercadoPagoContext.Site.MCO)
        
        // Title
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 0), 1)
        // Card
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 1), 2)
        // Discount
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 2), 1)
        // Payer Costs
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 3), self.instance!.numberOfCellsInBody())
        
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 6), 0)
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 6)), 0)
        
        
        // Title Cell
        XCTAssertTrue(self.instance!.isTitleCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), 40)
        
        // Card Cell
        XCTAssertTrue(self.instance!.isCardCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 1)), UIScreen.main.bounds.width * 0.50)
        XCTAssertTrue(self.instance!.showCardSection())
        XCTAssertTrue(self.instance!.isBankInterestCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 1, section: 1)), BankInsterestTableViewCell.cellHeight)
        
        // Discount Cell
        XCTAssertTrue(self.instance!.showAmountDetailRow())
        XCTAssertTrue(self.instance!.showDiscountSection())
        XCTAssertTrue(self.instance!.isDiscountCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), DiscountBodyCell.HEIGHT)
        
        // Payer Costs
        XCTAssertFalse(self.instance!.showPayerCostDescription())
        XCTAssertTrue(self.instance!.isBodyCellFor(indexPath: IndexPath(row: 0, section: 3)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 3)), 60)
        
        MercadoPagoContext.setSite(MercadoPagoContext.Site.MLA)
    }
    
    func testRowsNoDiscount() {
        /// Screen:
        /// ¿En cuantas Cuotas?
        /// (Tarjeta)
        /// (Total)
        /// (Cuotas)
        
        let flowPreference = FlowPreference()
        flowPreference.disableDiscount()
        MercadoPagoCheckout.setFlowPreference(flowPreference)
        
        MercadoPagoContext.setSite(MercadoPagoContext.Site.MLA)
        
        // Title
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 0), 1)
        // Card
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 1), 1)
        // Total
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 2), 1)
        // Payer Costs
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 3), self.instance!.numberOfCellsInBody())
        
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 6), 0)
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 6)), 0)
        
        
        // Title Cell
        XCTAssertTrue(self.instance!.isTitleCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), 40)
        
        // Card Cell
        XCTAssertTrue(self.instance!.isCardCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 1)), UIScreen.main.bounds.width * 0.50)
        XCTAssertTrue(self.instance!.showCardSection())
        XCTAssertFalse(self.instance!.isBankInterestCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 1, section: 1)), 0)
        
        // Total Cell
        XCTAssertTrue(self.instance!.showAmountDetailRow())
        XCTAssertFalse(self.instance!.showDiscountSection())
        XCTAssertFalse(self.instance!.isDiscountCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertNotEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), DiscountBodyCell.HEIGHT)
        XCTAssertTrue(self.instance!.isTotalCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), 42)
        
        // Payer Costs
        XCTAssertTrue(self.instance!.showPayerCostDescription())
        XCTAssertTrue(self.instance!.isBodyCellFor(indexPath: IndexPath(row: 0, section: 3)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 3)), 60)
        
    }
}

class IssuerAdditionalStepViewModelTest : BaseTest {
    var instance: IssuerAdditionalStepViewModel!
    
    override func setUp() {
        super.setUp()
        let issuer = MockBuilder.buildIssuer()
        let cardToken = MockBuilder.buildCardToken()
        let paymentMethod = MockBuilder.buildPaymentMethod("visa")
        self.instance = IssuerAdditionalStepViewModel(amount: 20.0, token: cardToken, paymentMethods: [paymentMethod], dataSource: [issuer])
    }
    
    func testTitle(){
        XCTAssertEqual(self.instance!.getTitle(), "¿Quién emitió tu tarjeta?".localized)
        XCTAssertEqual(self.instance!.maxFontSize, 24)
    }
    
    func testScreenName() {
        XCTAssertEqual(self.instance!.getScreenName(), "ISSUER")
    }
    
    func testNumberOfSections() {
        XCTAssertEqual(self.instance!.numberOfSections(), 4)
    }
    
    func testCardSectionView() {
        XCTAssertTrue(self.instance.getCardSectionView() is CardFrontView)
    }
    
    func testRows() {
        /// Screen:
        /// ¿Cual es tu banco?
        /// (Tarjeta)
        /// (Bancos)
        
        
        // Title
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 0), 1)
        // Card
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 1), 1)
        // Total
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 2), 0)
        // Issuers
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 3), self.instance!.numberOfCellsInBody())
        
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 6), 0)
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 6)), 0)
        
        
        // Title Cell
        XCTAssertTrue(self.instance!.isTitleCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), 40)
        
        // Card Cell
        XCTAssertTrue(self.instance!.isCardCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 1)), UIScreen.main.bounds.width * 0.50)
        XCTAssertTrue(self.instance!.showCardSection())
        XCTAssertFalse(self.instance!.isBankInterestCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 1, section: 1)), 0)
        
        // Total Cell
        XCTAssertFalse(self.instance!.showAmountDetailRow())
        XCTAssertFalse(self.instance!.showDiscountSection())
        XCTAssertFalse(self.instance!.isDiscountCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertNotEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), DiscountBodyCell.HEIGHT)
        XCTAssertFalse(self.instance!.isTotalCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertNotEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), 42)
        XCTAssertEqual(self.instance!.getAmountDetailCellHeight(indexPath: IndexPath(row: 0, section: 2)), 0)
        
        // Issuers
        XCTAssertTrue(self.instance!.showPayerCostDescription())
        XCTAssertTrue(self.instance!.isBodyCellFor(indexPath: IndexPath(row: 0, section: 3)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 3)), 80)
        
    }
}
