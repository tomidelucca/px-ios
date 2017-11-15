//
//  InstructionsContentComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsContentComponent: NSObject {
    var props: InstructionsContentProps
    
    init(props: InstructionsContentProps) {
        self.props = props
    }
}
class InstructionsContentProps: NSObject {
    var instruction: Instruction
    init(instruction: Instruction) {
        self.instruction = instruction
    }
}
