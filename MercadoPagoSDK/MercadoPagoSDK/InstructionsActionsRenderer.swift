//
//  InstructionsActionsRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsActionsRenderer: NSObject {
    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 30.0
    let M_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let ZERO_MARGIN: CGFloat = 0.0
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let ACCREDITATION_LABEL_FONT_SIZE: CGFloat = 12.0
    let ACCREDITATION_LABEL_FONT_COLOR: UIColor = .pxBrownishGray
    
    func render(instructionsActions: InstructionsActionsComponent) -> UIView {
        let instructionsActionsView = ActionsView()
        instructionsActionsView.translatesAutoresizingMaskIntoConstraints = false
        instructionsActionsView.backgroundColor = .pxLightGray
        var lastView: UIView?
        
        if let actionsArray = instructionsActions.props.instructionActions, !Array.isNullOrEmpty(actionsArray) {
            var loopsDone = 0
            for action in actionsArray {
                let actionView = buildActionView(with: action, in: instructionsActionsView, onBottomOf: lastView)
                instructionsActionsView.actionsViews?.append(actionView)
                lastView = actionView
                loopsDone += 1
            }
        }
        
        if let lastView = lastView {
            MPLayout.pinBottom(view: lastView, to: instructionsActionsView).isActive = true
        }
        
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
            MPLayout.put(view: actionView, onBottomOf: upperView, withMargin: L_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: actionView, to: superView, withMargin: L_MARGIN).isActive = true
        }

        return actionView
    }
}

class ActionsView: UIView {
    public var actionsViews: [UIView]?
}

