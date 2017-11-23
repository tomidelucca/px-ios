//
//  InstructionsActionsRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsActionsRenderer: NSObject {
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let ACCREDITATION_LABEL_FONT_SIZE: CGFloat = 12.0
    let ACCREDITATION_LABEL_FONT_COLOR: UIColor = .pxBrownishGray
    
    func render(instructionsActions: InstructionsActionsComponent) -> UIView {
        let instructionsActionsView = ActionsView()
        instructionsActionsView.translatesAutoresizingMaskIntoConstraints = false
        instructionsActionsView.backgroundColor = .pxLightGray
        var lastView: UIView?
        
        if let actionsArray = instructionsActions.props.instructionActions, !Array.isNullOrEmpty(actionsArray) {
            for action in actionsArray {
                let actionView = buildActionView(with: action, in: instructionsActionsView, onBottomOf: lastView)
                instructionsActionsView.actionsViews?.append(actionView)
                lastView = actionView
            }
        }
        
        MPLayout.pinLastSubviewToBottom(view: instructionsActionsView)?.isActive = true

        return instructionsActionsView
    }
    
    func buildActionView(with action: InstructionAction, in superView: UIView, onBottomOf upperView: UIView?, isFirstView: Bool = false) -> UIView {
        
        let actionRenderer = InstructionsActionRenderer()
        let actionProps = InstructionsActionProps(instructionActionInfo: action)
        let actionComponent = InstructionsActionComponent(props: actionProps)
        let actionView = actionRenderer.render(instructionsAction: actionComponent)
        superView.addSubview(actionView)
        MPLayout.setWidth(ofView: actionView, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: actionView, to: superView).isActive = true
        if let upperView = upperView {
            MPLayout.put(view: actionView, onBottomOf: upperView, withMargin: MPLayout.L_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: actionView, to: superView, withMargin: MPLayout.L_MARGIN).isActive = true
        }

        return actionView
    }
}

class ActionsView: UIView {
    public var actionsViews: [UIView]?
}

