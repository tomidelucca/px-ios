//
//  CardFlowTest.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 11/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class CardFlowTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardForm() {
       
        
        let app = XCUIApplication()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Components de UI"].tap()
        tablesQuery.staticTexts["Selección de medio de pago completa"].tap()
        tablesQuery.staticTexts["Tarjeta de crédito"].tap()

        
        CardFormActions.fillCreditCardForm(app)
        
    }
    
    
}
