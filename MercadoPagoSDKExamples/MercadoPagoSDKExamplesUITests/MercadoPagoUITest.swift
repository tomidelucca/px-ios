//
//  MercadoPagoUITest.swift
//  MercadoPagoSDKExamples
//
//  Created by Demian Tejo on 7/13/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

public class MercadoPagoUITest: XCTestCase {
    
    
    static var sharedApplication =  XCUIApplication()
    static var initializedApplication = false
    var application : XCUIApplication =  MercadoPagoUITest.sharedApplication
    
    override public func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        if(!MercadoPagoUITest.initializedApplication){
            MercadoPagoUITest.initializedApplication = true
            MercadoPagoUITest.sharedApplication.launchArguments = ["UITestingEnabled"]
            MercadoPagoUITest.sharedApplication.launch()
        }
        
        //application = MercadoPagoUITest.sharedApplication
        
    }

    
    override public func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func approvedUser() -> TestUser {
        let user = TestUser()
        user.name = "APRO"
        user.identification.number = "12123123"
        user.identification.type = "DNI"
        return user
    }
    
    func visa() -> TestCard {
        let card = TestCard()
        card.name = "visa"
        card.number = "4170068810108020"
        card.cvv = "123"
        return card
    }
    
    func amex() -> TestCard{
        let card = TestCard()
        card.name = "amex"
        card.number = "371180303257522"
        card.cvv = "1234"
        return card
    }
    
}

class TestCard : NSObject {
    
    var name : String = ""
    var number : String = ""
    var cvv : String = ""
    var expirationDate : String = "1122"
    
}

class TestUser : NSObject {
    
    var name : String = ""
    var identification : TestIdentification = TestIdentification()
    
}

class TestIdentification : NSObject {
    
    var type : String = ""
    var number : String = ""
}

