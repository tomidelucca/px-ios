//
//  CheckoutViewControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDK

class CheckoutViewControllerTest: BaseTest {
    
    var checkoutViewController : MockCheckoutViewController?
    var preference : CheckoutPreference?
    
    override func setUp() {
        super.setUp()
        self.preference = MockBuilder.buildCheckoutPreference()
        checkoutViewController = MockCheckoutViewController(preference: preference!, callback: {(payment : Payment) -> Void in
            
        })
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertEqual(checkoutViewController!.preference, preference)
        XCTAssertEqual(checkoutViewController!.publicKey, MercadoPagoContext.publicKey())
        XCTAssertEqual(checkoutViewController!.accessToken, MercadoPagoContext.merchantAccessToken())
        XCTAssertNil(checkoutViewController!.paymentMethod)
    }
    
    func testStartPaymentVaultInCheckout(){
        
        // Load view
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        
        //Verify preference has not mutated
        XCTAssertEqual(checkoutViewController!.preference, self.preference)
        
        // Check screen atributes are displayed properly
        checkInitialScreenAttributes()
        
    }
    
    func checkInitialScreenAttributes(){
        // Check preference description
        XCTAssertTrue(checkoutViewController!.displayPreferenceDescription)
        let sections = checkoutViewController?.numberOfSectionsInTableView((checkoutViewController?.checkoutTable)!)
        XCTAssertEqual(sections, 2)
        
        checkoutViewController?.checkoutTable.reloadData()
        XCTAssertNotNil(checkoutViewController?.checkoutTable)
        
        let preferenceDescriptionCell = checkoutViewController?.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! PreferenceDescriptionTableViewCell
        XCTAssertEqual(preferenceDescriptionCell.preferenceDescription.text, self.checkoutViewController?.preference?.items![0].title!)
        
        let preferenceAmount = preferenceDescriptionCell.preferenceAmount.attributedText
        
        let amountInCHOVC = self.checkoutViewController!.preference!.getAmount()
        let amountAttributedText = Utils.getAttributedAmount(String(amountInCHOVC), thousandSeparator: ",", decimalSeparator: ".", currencySymbol: "$")
        XCTAssertEqual(preferenceAmount!.string, amountAttributedText.string)
        
        let pmSelectionCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath:  NSIndexPath(forRow: 0, inSection: 1)) as! SelectPaymentMethodCell
        XCTAssertEqual(pmSelectionCell.selectPaymentMethodLabel.text, "Seleccione método de pago...".localized)
        
        let paymentTotalCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath:  NSIndexPath(forRow: 1, inSection: 1)) as! PaymentDescriptionFooterTableViewCell
       // XCTAssertEqual(paymentTotalCell.paymentTotalDescription.text, "Total a pagar $".localized + "\(amountInCHOVC)")
        
        let termsAndConditionsCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1)) as!TermsAndConditionsViewCell
        XCTAssertNotNil(termsAndConditionsCell)
        
        
    }
    
    func testTogglePreferenceDescription(){
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        XCTAssertTrue(self.checkoutViewController!.displayPreferenceDescription)
        self.checkoutViewController?.togglePreferenceDescription()
        XCTAssertFalse(self.checkoutViewController!.displayPreferenceDescription)
        
    }
    
    func testConfirmPaymentOff() {
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        self.checkoutViewController!.paymentMethod = MockBuilder.buildPaymentMethod("oxxo")
        self.checkoutViewController!.paymentMethod?.paymentTypeId = PaymentTypeId.TICKET

        let termsAndConditionsCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1)) as!TermsAndConditionsViewCell
        XCTAssertNotNil(termsAndConditionsCell)
        self.checkoutViewController!.paymentButton = termsAndConditionsCell.paymentButton
        
        self.checkoutViewController!.confirmPayment()
        //TODO
    }

    func testConfirmPaymentOn() {
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        self.checkoutViewController!.paymentMethod = MockBuilder.buildPaymentMethod("visa")
        self.checkoutViewController!.paymentMethod?.paymentTypeId = PaymentTypeId.CREDIT_CARD
        
        let termsAndConditionsCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1)) as!TermsAndConditionsViewCell
        XCTAssertNotNil(termsAndConditionsCell)
        self.checkoutViewController!.paymentButton = termsAndConditionsCell.paymentButton
        
       // self.checkoutViewController!.confirmPayment()
        //TODO
    }
    
    func testViewForFooterInSection() {
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        let noCopyrightCell = self.checkoutViewController?.tableView(self.checkoutViewController!.checkoutTable, viewForFooterInSection: 0)
        XCTAssertNil(noCopyrightCell)
        
        let copyrightCell = self.checkoutViewController?.tableView(self.checkoutViewController!.checkoutTable, viewForFooterInSection: 1)
        XCTAssertNotNil(copyrightCell)
        
        var footerHeight = self.checkoutViewController!.tableView(self.checkoutViewController!.checkoutTable, heightForFooterInSection: 0)
        XCTAssertEqual(footerHeight, 0)
        footerHeight = self.checkoutViewController!.tableView(self.checkoutViewController!.checkoutTable, heightForFooterInSection: 1)
        XCTAssertEqual(footerHeight, 140)
    }

    
    func testViewWillAppear(){
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        self.checkoutViewController?.viewWillAppear(true)
        XCTAssertTrue(self.checkoutViewController!.mpStylesLoaded)
    }

    func testOfflinePaymentMethodSelectedCell(){
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        self.checkoutViewController!.paymentMethod = MockBuilder.buildPaymentMethod("bancomer_ticket")
        self.checkoutViewController!.paymentMethod?.paymentTypeId = PaymentTypeId.TICKET
        self.checkoutViewController!.paymentMethod!.comment = "comment"
        
        let paymentMethodCell = self.checkoutViewController!.tableView(self.checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! OfflinePaymentMethodCell
        XCTAssertEqual(checkoutViewController?.title, "Revisa si está todo bien...".localized)
        let termsAndConditions = self.checkoutViewController!.tableView(self.checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1)) as! TermsAndConditionsViewCell
        XCTAssertEqual(termsAndConditions.termsAndConditionsText.text, "Al pagar afirme que es mayor de edad y acepto los términos y condiciones de Mercado Pago")
        let cellComment = paymentMethodCell.comment.text!
        XCTAssertEqual(cellComment, self.checkoutViewController!.paymentMethod!.comment!)
        
        
    }
    
}
