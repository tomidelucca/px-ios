//
//  PaymentResultViewModelTest.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 4/25/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDK
class PaymentResultViewModelTest : BaseTest {
    
    var instance: PaymentResultViewModel!
    var paymentData: PaymentData!
    var paymentResult: PaymentResult!
    override func setUp() {
        super.setUp()
        
        self.paymentData = MockBuilder.buildPaymentData(paymentMethodId: "visa", installments: 1, installmentRate: 0)
        self.paymentResult = PaymentResult(status: "approved", statusDetail: "", paymentData: paymentData, payerEmail: "sarsa@sarasita.com", id: "123", statementDescription: "mercadopago")
        self.instance = PaymentResultViewModel(paymentResult: paymentResult, checkoutPreference: CheckoutPreference(), callback: { (state) in})
    }
    
    //*********************
    // General
    //*********************
    
    func testPaymentTrackingInfo(){
        XCTAssertEqual(self.instance.getMethodId(), self.paymentResult.paymentData?.paymentMethod._id)
        XCTAssertEqual(self.instance.getStatus(), self.paymentResult.status)
        XCTAssertEqual(self.instance.getStatusDetail(), self.paymentResult.statusDetail)
        XCTAssertEqual(self.instance.getTypeId(), self.paymentResult.paymentData?.paymentMethod.paymentTypeId)
        XCTAssertEqual(self.instance.getInstallments(), String(describing: paymentResult.paymentData?.payerCost?.installments))
        XCTAssertEqual(self.instance.getIssuerId(), String(describing: paymentResult.paymentData?.issuer?._id))
    }
    
    func testNumberOfSections(){
        XCTAssertEqual(self.instance!.numberOfSections(), 6)
    }
    
    //*********************
    // APPROVED PAYMENTS
    //*********************
    
    func testStatus() {
        XCTAssertTrue(self.instance.isApproved())
        XCTAssertFalse(self.instance.isPending())
        XCTAssertFalse(self.instance.isRejected())
        XCTAssertFalse(self.instance.isCallForAuth())
    }
    
    func testGetColor() {
        XCTAssertEqual(self.instance!.getColor(), UIColor.px_greenCongrats())
    }
    
    func testLayoutName() {
        XCTAssertEqual(self.instance.getLayoutName(), "approved")
    }
    
    func testRowsDefault() {
        /// HEADER
        /// APPROVED CELL
        /// EMAIL
        /// EXIT BUTTON
        
        // Header
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 0), 1)
        // SubHeader
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 1), 0)
        // Body
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 2), 2)
        // Additional Cells
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 3), 0)
        // Secondary Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 4), 0)
        // Exit Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 5), 1)
        
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 100), 0)
        
        
        // Header
        XCTAssertTrue(self.instance.isHeaderCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), UITableViewAutomaticDimension)
        
        // SubHeader
        XCTAssertFalse(self.instance.isApprovedCustomSubHeaderCellFor(indexPath: IndexPath(row: 0, section: 1)))
        
        // Approved Body
        XCTAssertTrue(self.instance.isApprovedBodyCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), UITableViewAutomaticDimension)
        
        // Email
        XCTAssertTrue(self.instance.isEmailCellFor(indexPath: IndexPath(row: 1, section: 2)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 1, section: 2)), UITableViewAutomaticDimension)
        
        // Additional Cells
        XCTAssertFalse(self.instance.isApprovedAdditionalCustomCellFor(indexPath: IndexPath(row: 0, section: 3)))
        
        // Secondary Button
        XCTAssertFalse(self.instance.isSecondaryExitButtonCellFor(indexPath: IndexPath(row: 0, section: 4)))
        XCTAssertFalse(self.instance.shouldShowSecondaryExitButton())
        
        //ExitButton
        XCTAssertTrue(self.instance.isFooterCellFor(indexPath: IndexPath(row: 0, section: 5)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 5)), UITableViewAutomaticDimension)
    }
    
    func testRowsDefaultNoApprovedBody() {
        let paymentPreference = PaymentResultScreenPreference()
        paymentPreference.disableApprovedBodyCell()
        self.instance.paymentResultScreenPreference = paymentPreference
        
        /// HEADER
        /// Email
        /// EXIT BUTTON
        
        // Header
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 0), 1)
        // SubHeader
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 1), 0)
        // Body
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 2), 1)
        // Additional Cells
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 3), 0)
        // Secondary Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 4), 0)
        // Exit Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 5), 1)
        
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 100), 0)
        
        
        // Header
        XCTAssertTrue(self.instance.isHeaderCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), UITableViewAutomaticDimension)
        
        // SubHeader
        XCTAssertFalse(self.instance.isApprovedCustomSubHeaderCellFor(indexPath: IndexPath(row: 0, section: 1)))
        
        // Approved Body
        XCTAssertFalse(self.instance.isApprovedBodyCellFor(indexPath: IndexPath(row: 0, section: 2)))
        
        // Email
        XCTAssertTrue(self.instance.isEmailCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), UITableViewAutomaticDimension)
        
        // Additional Cells
        XCTAssertFalse(self.instance.isApprovedAdditionalCustomCellFor(indexPath: IndexPath(row: 0, section: 3)))
        
        // Secondary Button
        XCTAssertFalse(self.instance.isSecondaryExitButtonCellFor(indexPath: IndexPath(row: 0, section: 4)))
        XCTAssertFalse(self.instance.shouldShowSecondaryExitButton())
        
        //ExitButton
        XCTAssertTrue(self.instance.isFooterCellFor(indexPath: IndexPath(row: 0, section: 5)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 5)), UITableViewAutomaticDimension)
        
    }
    
    func testRowsDefaultNoApprovedBodyAndEmail() {
        
        let paymentPreference = PaymentResultScreenPreference()
        paymentPreference.disableApprovedBodyCell()
        self.instance.paymentResultScreenPreference = paymentPreference
        self.instance.paymentResult.payerEmail = ""
        
        /// HEADER
        /// EXIT BUTTON
        
        // Header
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 0), 1)
        // SubHeader
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 1), 0)
        // Body
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 2), 0)
        // Additional Cells
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 3), 0)
        // Secondary Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 4), 0)
        // Exit Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 5), 1)
        
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 100), 0)
        
        
        // Header
        XCTAssertTrue(self.instance.isHeaderCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), UITableViewAutomaticDimension)
        
        // SubHeader
        XCTAssertFalse(self.instance.isApprovedCustomSubHeaderCellFor(indexPath: IndexPath(row: 0, section: 1)))
        
        // Approved Body
        XCTAssertFalse(self.instance.isApprovedBodyCellFor(indexPath: IndexPath(row: 0, section: 2)))
        
        // Email
        XCTAssertFalse(self.instance.isEmailCellFor(indexPath: IndexPath(row: 0, section: 2)))
        
        // Additional Cells
        XCTAssertFalse(self.instance.isApprovedAdditionalCustomCellFor(indexPath: IndexPath(row: 0, section: 3)))
        
        // Secondary Button
        XCTAssertFalse(self.instance.isSecondaryExitButtonCellFor(indexPath: IndexPath(row: 0, section: 4)))
        XCTAssertFalse(self.instance.shouldShowSecondaryExitButton())
        
        //ExitButton
        XCTAssertTrue(self.instance.isFooterCellFor(indexPath: IndexPath(row: 0, section: 5)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 5)), UITableViewAutomaticDimension)
    }
    
    func testRowsCustomCells() {
        
        let paymentPreference = PaymentResultScreenPreference()
        paymentPreference.approvedAdditionalInfoCells = [MPCustomCell(cell: UITableViewCell())]
        paymentPreference.approvedSubHeaderCells = [MPCustomCell(cell: UITableViewCell())]
        self.instance.paymentResultScreenPreference = paymentPreference
        
        /// HEADER
        /// SUBHEHEADER
        /// APPROVED CELL
        /// EMAIL
        /// ADDITIONAL CELL
        /// EXIT BUTTON
        
        // Header
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 0), 1)
        // SubHeader
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 1), self.instance.numberOfCustomSubHeaderCells())
        // Body
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 2), 2)
        // Additional Cells
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 3), self.instance.numberOfCustomAdditionalCells())
        // Secondary Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 4), 0)
        // Exit Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 5), 1)
        
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 100), 0)
        
        
        // Header
        XCTAssertTrue(self.instance.isHeaderCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), UITableViewAutomaticDimension)
        
        // SubHeader
        XCTAssertTrue(self.instance.isApprovedCustomSubHeaderCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 1)), 0)
        
        // Approved Body
        XCTAssertTrue(self.instance.isApprovedBodyCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), UITableViewAutomaticDimension)
        
        // Email
        XCTAssertTrue(self.instance.isEmailCellFor(indexPath: IndexPath(row: 1, section: 2)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 1, section: 2)), UITableViewAutomaticDimension)
        
        // Additional Cells
        XCTAssertTrue(self.instance.isApprovedAdditionalCustomCellFor(indexPath: IndexPath(row: 0, section: 3)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 3)), 0)
        
        // Secondary Button
        XCTAssertFalse(self.instance.isSecondaryExitButtonCellFor(indexPath: IndexPath(row: 0, section: 4)))
        XCTAssertFalse(self.instance.shouldShowSecondaryExitButton())
        
        //ExitButton
        XCTAssertTrue(self.instance.isFooterCellFor(indexPath: IndexPath(row: 0, section: 5)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 5)), UITableViewAutomaticDimension)
    }
    
    func testRowsSecondaryButton() {
        
        let paymentPreference = PaymentResultScreenPreference()
        paymentPreference.setApprovedSecondaryExitButton(callback: { (pr) in
            
        }, text: "sarsa")
        self.instance.paymentResultScreenPreference = paymentPreference
        
        /// HEADER
        /// APPROVED CELL
        /// EMAIL
        /// SECONDARY BUTTON
        /// EXIT BUTTON
        
        // Header
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 0), 1)
        // SubHeader
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 1), 0)
        // Body
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 2), 2)
        // Additional Cells
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 3), 0)
        // Secondary Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 4), 1)
        // Exit Button
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 5), 1)
        
        XCTAssertEqual(self.instance.numberOfRowsInSection(section: 100), 0)
        
        
        // Header
        XCTAssertTrue(self.instance.isHeaderCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), UITableViewAutomaticDimension)
        
        // SubHeader
        XCTAssertFalse(self.instance.isApprovedCustomSubHeaderCellFor(indexPath: IndexPath(row: 0, section: 1)))
        
        // Approved Body
        XCTAssertTrue(self.instance.isApprovedBodyCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), UITableViewAutomaticDimension)
        
        // Email
        XCTAssertTrue(self.instance.isEmailCellFor(indexPath: IndexPath(row: 1, section: 2)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 1, section: 2)), UITableViewAutomaticDimension)
        
        // Additional Cells
        XCTAssertFalse(self.instance.isApprovedAdditionalCustomCellFor(indexPath: IndexPath(row: 0, section: 3)))
        
        // Secondary Button
        XCTAssertTrue(self.instance.isSecondaryExitButtonCellFor(indexPath: IndexPath(row: 0, section: 4)))
        XCTAssertTrue(self.instance.shouldShowSecondaryExitButton())
        
        //ExitButton
        XCTAssertTrue(self.instance.isFooterCellFor(indexPath: IndexPath(row: 0, section: 5)))
        XCTAssertEqual(self.instance.heightForRowAt(indexPath: IndexPath(row: 0, section: 5)), UITableViewAutomaticDimension)
    }


    


}
