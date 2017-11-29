//
//  PXInstructionsActionsComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsActionsComponent: NSObject, PXComponetizable {
    var props: PXInstructionsActionsProps

    init(props: PXInstructionsActionsProps) {
        self.props = props
    }
    
    public func getActionComponents() -> [InstructionsActionComponent] {
        var actionComponents: [InstructionsActionComponent] = []
        if let actions = props.instructionActions, !actions.isEmpty {
            for action in actions {
                if action.tag == ActionTag.LINK.rawValue {
                    let actionProps = InstructionsActionProps(instructionActionInfo: action)
                    let actionComponent = InstructionsActionComponent(props: actionProps)
                    actionComponents.append(actionComponent)
                }
            }
        }
        return actionComponents
    }
    
    func render() -> UIView {
        return PXInstructionsActionsRenderer().render(instructionsActions: self)
    }
}
class PXInstructionsActionsProps: NSObject {
    var instructionActions: [InstructionAction]?
    init(instructionActions: [InstructionAction]?) {
        self.instructionActions = instructionActions
    }
}
