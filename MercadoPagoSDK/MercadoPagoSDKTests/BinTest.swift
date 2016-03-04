//
//  BinTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class BinTest: BaseTest {
    
    
    
    func testFromJSON(){
        let json : NSDictionary = MockManager.getMockFor("Bin")!
        let binFromJSON = Bin.fromJSON(json)
        XCTAssertEqual(binFromJSON, binFromJSON)
    }
    
    
}
