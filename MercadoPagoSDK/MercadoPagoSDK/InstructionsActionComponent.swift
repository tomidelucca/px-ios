//
//  InstructionsActionComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsActionComponent: NSObject {
    var props: InstructionsActionProps
    
    init(props: InstructionsActionProps) {
        self.props = props
    }
}
class InstructionsActionProps: NSObject {
    var instructionActionInfo: InstructionAction?
    init(instructionActionInfo: InstructionAction?) {
        self.instructionActionInfo = instructionActionInfo
    }
}

