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
    var expectations = ExpectationHash()

    private override init() {
        
    }
    
    class func addExpectation(expectation : XCTestExpectation){
        self.sharedInstance.expectations.add(expectation)
    }
    
    class func fulfillExpectation(withKey : String) {
        if self.sharedInstance.expectations.count() > 0 {
            self.sharedInstance.expectations.fulfillExpectation(withKey)
        }
    }

    
}

struct ExpectationHash {
    var items = [String : XCTestExpectation]()
    mutating func add(expectation: XCTestExpectation) {
        items[expectation.description] = expectation
    }
    
    mutating func remove(withKey : String) {
        items.removeValueForKey(withKey)
    }
    
    mutating func count() -> Int {
        return items.count
    }
    
    mutating func show() {
        print(items)
    }
    
    func fulfillExpectation(withKey : String) {
        if let expectation = items[withKey] {
            expectation.fulfill()
        }
    }
}