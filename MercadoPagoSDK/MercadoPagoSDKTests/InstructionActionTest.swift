//
//  InstructionActionTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class InstructionActionTest: BaseTest {
    
    func testInit(){
        let instructionAction = InstructionAction(label: "label", url: "url", tag: "tag")
        XCTAssertEqual(instructionAction.label, "label")
        XCTAssertEqual(instructionAction.url, "url")
        XCTAssertEqual(instructionAction.tag, "tag")
    }
    
}
