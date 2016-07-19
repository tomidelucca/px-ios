//
//  CheckoutFlowTest.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 11/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//
import XCTest


public class CheckoutFlowTest: MercadoPagoUITest {
    
    
    
    func testCheckOutWithCard(){
        let tablesQuery = application.tables
        tablesQuery.cells.elementBoundByIndex(0).tap()
        tablesQuery.cells.elementBoundByIndex(0).tap()
        CardFormActions.testCard(tarshopWithoutCVV(), user: approvedUser())
        tablesQuery.cells.elementBoundByIndex(0).tap()
        tablesQuery.buttons["Pagar"].tap()
        tablesQuery.buttons["Seguir comprando"].tap()
        
    }
    
 
}
