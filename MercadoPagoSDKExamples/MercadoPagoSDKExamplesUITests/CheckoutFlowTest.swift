//
//  CheckoutFlowTest.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 11/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//
import XCTest


class CheckoutFlowTest: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let application = XCUIApplication()
        application.launchArguments = ["UITestingEnabled"]
        application.launch()
        

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCheckoutFlow() {
        
        let app = XCUIApplication()
        
        app.tables.staticTexts["Nuestro Checkout"].tap()

        
        let choOptionsAvailable = app.tables.cells.count
        XCTAssertEqual(choOptionsAvailable, 3)
        
        XCTAssertTrue(CommonActions.optionCellsAvaiable(["Tarjeta de crédito", "Efectivo", "Transferencia por Red Link"]))
        

        app.tables.staticTexts["Efectivo"].tap()
        let cashOptionsAvailable = app.tables.cells.count
        XCTAssertEqual(cashOptionsAvailable, 3)
        
        app.navigationBars["¿Dónde quieres pagar?"].childrenMatchingType(.Button).elementBoundByIndex(0).tap()
        
        app.tables.staticTexts["Transferencia por Red Link"].tap()
        let bankTransferLinkOptions = app.tables.cells.count
        XCTAssertEqual(bankTransferLinkOptions, 3)
        
        app.navigationBars["¿Cómo quieres pagar?"].childrenMatchingType(.Button).elementBoundByIndex(0).tap()
        
        
        
    }
    
}
