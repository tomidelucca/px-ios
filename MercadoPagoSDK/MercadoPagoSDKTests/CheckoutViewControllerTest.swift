//
//  CheckoutViewControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

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
        checkScreenAttributes()
        
    }
    
    func checkScreenAttributes(){
        // Check preference description
        XCTAssertTrue(checkoutViewController!.displayPreferenceDescription)
        let preferenceDescriptionCell = checkoutViewController?.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! PreferenceDescriptionTableViewCell
        XCTAssertEqual(preferenceDescriptionCell.preferenceDescription, self.checkoutViewController?.preference?.items![0].title!)
        XCTAssertEqual(preferenceDescriptionCell.preferenceAmount, "$" + String(self.preference?.getAmount()))
        //TODO:verify image path        XCTAssertEqual(preferenceDescriptionCell.shoppingCartIcon.pa,
        
        // Check empty select payment method cell
        let cell = checkoutViewController?.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! SelectPaymentMethodCell
        XCTAssertEqual(cell.selectPaymentMethodLabel!.text,"Seleccione método de pago...")
        XCTAssertTrue(checkoutViewController!.confirmPaymentButton.hidden)
        
        
    }
    
}
