//
//  CardFlowTest.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 11/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class CardFlowTest: MercadoPagoUITest {
    
   
    func testCardForm() {
 
        testApproved(visa())
        testApproved(amex())
    }
    
    
    
    func testApproved(card:TestCard){
        self.testCard(card, user: approvedUser())
    }
    
    func testCard(card : TestCard , user : TestUser){
        let tablesQuery = application.tables
        tablesQuery.staticTexts["Components de UI"].tap()
        tablesQuery.staticTexts["Cobra con tarjeta con cuotas"].tap()
        CardFormActions.testCard(card, user: user)
        backToMenu()
    }
    
    
    func backToMenu(){
        
        let cMoQuieresPagarNavigationBar = XCUIApplication().navigationBars[""]
        cMoQuieresPagarNavigationBar.childrenMatchingType(.Button).elementBoundByIndex(1).tap()
        cMoQuieresPagarNavigationBar.childrenMatchingType(.Button).elementBoundByIndex(0).tap()
        
    }
    
}
