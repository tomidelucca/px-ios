//
//  InstructionsActionsComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsActionsComponent: NSObject {
    var props: InstructionsActionsProps
    
    init(props: InstructionsActionsProps) {
        self.props = props
    }
}
class InstructionsActionsProps: NSObject {
    var instructionActions: [InstructionAction]?
    init(instructionActions: [InstructionAction]?) {
        self.instructionActions = instructionActions
    }
}
