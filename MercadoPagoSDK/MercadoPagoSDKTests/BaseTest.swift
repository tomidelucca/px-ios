//
//  BaseCase.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 21/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class BaseTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func simulateViewDidLoadFor(viewController : UIViewController){
        let nav = UINavigationController()
        nav.pushViewController(viewController, animated: false)
        let _ = viewController.view
    }
    
    
    
}
