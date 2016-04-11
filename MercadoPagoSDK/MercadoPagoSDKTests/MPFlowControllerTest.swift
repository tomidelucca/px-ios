//
//  MPFlowControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 5/4/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class MPFlowControllerTest: BaseTest {
    
    let mockViewController = MockPaymentVaultViewController(amount: 1, currencyId: "MXN", purchaseTitle: "title", excludedPaymentTypes: nil, excludedPaymentMethods: nil, defaultPaymentMethodId: nil, installments: 1, defaultInstallments: 1) { (paymentMethod, cardToken, issuer, installments) -> Void in

    }
    
    let rootMockViewController = MockPaymentVaultViewController(amount: 1, currencyId: "MXN", purchaseTitle: "title", excludedPaymentTypes: nil, excludedPaymentMethods: nil, defaultPaymentMethodId: nil, installments: 1, defaultInstallments: 1) { (paymentMethod, cardToken, issuer, installments) -> Void in
        
    }
    
    override func setUp() {
        super.setUp()
        MPFlowController.createNavigationControllerWith(mockViewController)
        
    }
    
    func testCreateNavigationControllerWith(){
        XCTAssertNotNil(MPFlowController.sharedInstance)
        let navigationController = MPFlowController.createNavigationControllerWith(mockViewController)
        XCTAssertNotNil(navigationController)
    }
    
    func testPop(){
        
        XCTAssertTrue(MPFlowController.sharedInstance.navigationController?.viewControllers.count == 1)
        let anotherMockViewController = MockPaymentVaultViewController(amount: 1, currencyId: "MXN", purchaseTitle: "title", excludedPaymentTypes: nil, excludedPaymentMethods: nil, defaultPaymentMethodId: nil, installments: 1, defaultInstallments: 1) { (paymentMethod, cardToken, issuer, installments) -> Void in
            
        }
        MPFlowController.push(anotherMockViewController, animated: false)
        XCTAssertTrue(MPFlowController.sharedInstance.navigationController?.viewControllers.count == 2)
        MPFlowController.pop(false)
        XCTAssertTrue(MPFlowController.sharedInstance.navigationController?.viewControllers.count == 1)
    }
    
    func testDismiss(){
        XCTAssertTrue(MPFlowController.sharedInstance.navigationController?.viewControllers.count > 0)
        MPFlowController.dismiss(false)
        
    }
    
    func testPopToRoot() {
        MPFlowController.createNavigationControllerWith(rootMockViewController)
        MPFlowController.push(mockViewController, animated : false)
        MPFlowController.push(mockViewController, animated : false)
        XCTAssertTrue((MPFlowController.sharedInstance.navigationController?.viewControllers)! == 3)
        MPFlowController.popToRoot(false)
        XCTAssertTrue((MPFlowController.sharedInstance.navigationController?.viewControllers)! == 1)
        XCTAssertEqual(MPFlowController.sharedInstance.navigationController?.viewControllers[0], rootMockViewController)
    }
}
