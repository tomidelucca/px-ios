//
//  MercadoPagoTestContext.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 18/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import XCTest

public class MercadoPagoTestContext : NSObject {
    
    static let sharedInstance = MercadoPagoTestContext()
    var expectation : XCTestExpectation? = nil

    private override init() {
        
    }
    
    class func fulfillExpectation(){
        if self.sharedInstance.expectation != nil {
            self.sharedInstance.expectation?.fulfill()
        }
    }

    
}
