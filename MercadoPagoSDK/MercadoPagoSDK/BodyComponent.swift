//
//  BodyComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

open class BodyComponent: NSObject, PXComponetizable {
    var props: BodyProps
    
    init(props: BodyProps) {
        self.props = props
    }

    public func hasInstructions() -> Bool {
        return props.instruction != nil
    }
    
    public func getInstructionsComponent() -> InstructionsComponent? {
        let instructionsProps = InstructionsProps(instruction: props.instruction!)
        let instructionsComponent = InstructionsComponent(props: instructionsProps)
        return instructionsComponent
    }
    public func render() -> UIView {
        return BodyRenderer().render(body: self)
    }
    
}
open class BodyProps: NSObject {
    var status: String
    var statusDetail: String
    var instruction: Instruction?
    init(status: String, statusDetail: String, instruction: Instruction?) {
        self.status = status
        self.statusDetail = statusDetail
        self.instruction = instruction
    }
}
