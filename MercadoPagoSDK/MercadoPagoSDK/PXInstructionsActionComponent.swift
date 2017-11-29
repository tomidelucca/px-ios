//
//  PXInstructionsActionComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsActionComponent: NSObject, PXComponetizable {
    var props: InstructionsActionProps

    init(props: InstructionsActionProps) {
        self.props = props
    }
    func render() -> UIView {
        return InstructionsActionRenderer().render(instructionsAction: self)
    }
}
class InstructionsActionProps: NSObject {
    var instructionActionInfo: InstructionAction?
    init(instructionActionInfo: InstructionAction?) {
        self.instructionActionInfo = instructionActionInfo
    }
}
