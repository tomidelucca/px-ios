//
//  PXInstructionsReferenceComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsReferenceComponent: NSObject, PXComponetizable {
    var props: InstructionReferenceProps

    init(props: InstructionReferenceProps) {
        self.props = props
    }
    func render() -> UIView {
        return InstructionReferenceRenderer().render(instructionReference: self)
    }
}
class InstructionReferenceProps: NSObject {
    var reference: InstructionReference?
    init(reference: InstructionReference?) {
        self.reference = reference
    }
}
