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
        
        for action in instructionsActions.getActionComponents() {
            let actionView = buildActionView(with: action, in: instructionsActionsView, onBottomOf: lastView)
            instructionsActionsView.actionsViews = Array.safeAppend(instructionsActionsView.actionsViews, actionView)
            lastView = actionView
        }
        
        MPLayout.pinLastSubviewToBottom(view: instructionsActionsView)?.isActive = true

        return instructionsActionsView
    }
    
    func buildActionView(with action: InstructionsActionComponent, in superView: UIView, onBottomOf upperView: UIView?, isFirstView: Bool = false) -> UIView {
        let actionView = action.render()
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

