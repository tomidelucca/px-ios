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
        
        
        //Verify paymentVault was loaded
        XCTAssertTrue(checkoutViewController!.paymentVaultLoaded)
        
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
        let preferenceAmount = preferenceDescriptionCell.preferenceAmount.text
        let amountInCHOVC = self.checkoutViewController?.preference?.getAmount()
        XCTAssertEqual(preferenceAmount!, "$\(amountInCHOVC!)")
        
        let pmSelectionCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath:  NSIndexPath(forRow: 0, inSection: 1)) as! SelectPaymentMethodCell
        XCTAssertEqual(pmSelectionCell.selectPaymentMethodLabel.text, "Seleccione método de pago...".localized)
        
        let paymentTotalCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath:  NSIndexPath(forRow: 1, inSection: 1)) as! PaymentDescriptionFooterTableViewCell
        XCTAssertEqual(paymentTotalCell.paymentTotalDescription.text, "Total a pagar $".localized + "\(amountInCHOVC!)")
        
        let termsAndConditionsCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1)) as!TermsAndConditionsViewCell
        XCTAssertNotNil(termsAndConditionsCell)
        
        
    }
    
    func testTogglePreferenceDescription(){
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        XCTAssertTrue(self.checkoutViewController!.displayPreferenceDescription)
        self.checkoutViewController?.togglePreferenceDescription()
        XCTAssertFalse(self.checkoutViewController!.displayPreferenceDescription)
        
    }
    
    func testTestConfirmPayment(){
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        self.checkoutViewController!.paymentMethod = MockBuilder.buildPaymentMethod("oxxo")
        self.checkoutViewController!.paymentMethod?.paymentTypeId = PaymentTypeId.TICKET
        self.checkoutViewController!.confirmPayment()
    }
    
    func testViewWillLoad(){
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
        let cellComment = paymentMethodCell.comment.text!
        XCTAssertEqual(cellComment, self.checkoutViewController!.paymentMethod!.comment!)
        
        
    }
    
}
