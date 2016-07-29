//
//  BaseCase.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 21/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class BaseTest: XCTestCase {
    
    static let WAIT_FOR_REQUEST_EXPECTATION_DESCRIPTION = "waitForRequest"
    static let WAIT_FOR_NAVIGATION_CONTROLLER = "waitForNavigationController"
    static let WAIT_EXPECTATION_TIME_INTERVAL = 1000.0
    
    override func setUp() {
        super.setUp()
        MercadoPagoContext.setPublicKey(MockBuilder.MLA_PK)
        MercadoPagoContext.setMerchantAccessToken(MockBuilder.MERCHANT_ACCESS_TOKEN)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func simulateViewDidLoadFor(viewController : UIViewController) -> UIViewController{
       // MercadoPagoUIViewController.loadFont(MercadoPago.DEFAULT_FONT_NAME)
        MercadoPagoTestContext.addExpectation(expectationWithDescription(BaseTest.WAIT_FOR_NAVIGATION_CONTROLLER))
        let nav = UINavigationController()
        nav.pushViewController(viewController, animated: false) {
            MercadoPagoTestContext.fulfillExpectation(BaseTest.WAIT_FOR_NAVIGATION_CONTROLLER)
        }
        let _ = viewController.view
        waitForExpectationsWithTimeout(BaseTest.WAIT_EXPECTATION_TIME_INTERVAL, handler: nil)
        viewController.viewDidLoad()
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
        return viewController
    }
    
    
    
}

extension UINavigationController {
    
    func pushViewController(viewController: UIViewController,
                            animated: Bool, completion: Void -> Void) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
}