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
 
        testApproved(diners())
    }
 /*
    func testAllCards(){
      
      //  for (_, card) in cardsTestArray!.enumerate() {
        for (_, card) in cardsForDemo!.enumerate() {
            print("---------------------------------------------------------")
            print("Testing  \(card.name)")
            testApproved(card)
            backToMenu()
        }
    }
    
    */
    func testApproved(card:TestCard){
        self.testCard(card, user: approvedUser())
    }
    
    func testCard(card : TestCard , user : TestUser){
        let tablesQuery = CardFlowTest.application.tables
        tablesQuery.cells.elementBoundByIndex(1).tap()
        tablesQuery.cells.elementBoundByIndex(1).tap()
        CardFormActions.testCard(card, user: user)
        
    }
    
    
    func backToMenu(){
        
        let cMoQuieresPagarNavigationBar = XCUIApplication().navigationBars[""]
        cMoQuieresPagarNavigationBar.childrenMatchingType(.Button).elementBoundByIndex(1).tap()
        cMoQuieresPagarNavigationBar.childrenMatchingType(.Button).elementBoundByIndex(0).tap()
        
    }
    
}
