//
//  InstructionsContentRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsContentRenderer: NSObject {
    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 30.0
    let M_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let XS_MARGIN: CGFloat = 10.0
    let XXS_MARGIN: CGFloat = 5.0
    let ZERO_MARGIN: CGFloat = 0.0
    
    func render(instructionsContent: InstructionsContentComponent) -> UIView {
        let instructionsContentView = ContentView()
        instructionsContentView.translatesAutoresizingMaskIntoConstraints = false
        instructionsContentView.backgroundColor = .blue
        var bottomView: UIView!

        if instructionsContent.hasInfo() {
            let instructionsInfoRenderer = InstructionsInfoRenderer()
            instructionsContentView.infoView = instructionsInfoRenderer.render(instructionsInfo: instructionsContent.getInfoComponent())
            instructionsContentView.addSubview(instructionsContentView.infoView!)
            MPLayout.pinTop(view: instructionsContentView.infoView!, to: instructionsContentView).isActive = true
            MPLayout.centerHorizontally(view: instructionsContentView.infoView!, to: instructionsContentView).isActive = true
            MPLayout.equalizeWidth(view: instructionsContentView.infoView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.infoView
        }
        
        if instructionsContent.hasReferences() {
            let instructionsReferencesRenderer = InstructionsReferencesRenderer()
            instructionsContentView.referencesView = instructionsReferencesRenderer.render(instructionsReferences: instructionsContent.getReferencesComponent())
            instructionsContentView.addSubview(instructionsContentView.referencesView!)
            if let lastView = bottomView {
                MPLayout.put(view: instructionsContentView.referencesView!, onBottomOf: lastView).isActive = true
            } else {
                MPLayout.pinTop(view: instructionsContentView.referencesView!, to: instructionsContentView).isActive = true
            }

            MPLayout.centerHorizontally(view: instructionsContentView.referencesView!, to: instructionsContentView).isActive = true
            MPLayout.equalizeWidth(view: instructionsContentView.referencesView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.referencesView
        }

        if instructionsContent.hasTertiaryInfo() {
            let instructionsTertiaryInfoRenderer = InstructionsTertiaryInfoRenderer()
            instructionsContentView.tertiaryInfoView = instructionsTertiaryInfoRenderer.render(instructionsTertiaryInfo: instructionsContent.getTertiaryInfoComponent())
            instructionsContentView.addSubview(instructionsContentView.tertiaryInfoView!)
            if let lastView = bottomView {
                MPLayout.put(view: instructionsContentView.tertiaryInfoView!, onBottomOf: lastView).isActive = true
            } else {
                MPLayout.pinTop(view: instructionsContentView.tertiaryInfoView!, to: instructionsContentView).isActive = true
            }
            MPLayout.centerHorizontally(view: instructionsContentView.tertiaryInfoView!, to: instructionsContentView).isActive = true
            MPLayout.equalizeWidth(view: instructionsContentView.tertiaryInfoView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.tertiaryInfoView
        }
        
        if instructionsContent.hasAccreditationTime() {
            let instructionsAccreditationTimeRenderer = InstructionsAccreditationTimeRenderer()
            instructionsContentView.accreditationTimeView = instructionsAccreditationTimeRenderer.render(instructionsAccreditationTime: instructionsContent.getAccreditationTimeComponent())
            instructionsContentView.addSubview(instructionsContentView.accreditationTimeView!)
            if let lastView = bottomView {
                MPLayout.put(view: instructionsContentView.accreditationTimeView!, onBottomOf: lastView).isActive = true
            } else {
                MPLayout.pinTop(view: instructionsContentView.accreditationTimeView!, to: instructionsContentView).isActive = true
            }
            
            MPLayout.centerHorizontally(view: instructionsContentView.accreditationTimeView!, to: instructionsContentView).isActive = true
            MPLayout.equalizeWidth(view: instructionsContentView.accreditationTimeView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.accreditationTimeView
        }
        if instructionsContent.hasActions() {
            let instructionsActionsRenderer = InstructionsActionsRenderer()
            instructionsContentView.actionsView = instructionsActionsRenderer.render(instructionsActions: instructionsContent.getActionsComponent())
            instructionsContentView.addSubview(instructionsContentView.actionsView!)
            if let lastView = bottomView {
                MPLayout.put(view: instructionsContentView.actionsView!, onBottomOf: lastView).isActive = true
            } else {
                MPLayout.pinTop(view: instructionsContentView.actionsView!, to: instructionsContentView).isActive = true
            }
            
            MPLayout.centerHorizontally(view: instructionsContentView.actionsView!, to: instructionsContentView).isActive = true
            MPLayout.equalizeWidth(view: instructionsContentView.actionsView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.actionsView
        }

        MPLayout.pinBottom(view: bottomView, to: instructionsContentView, withMargin: L_MARGIN).isActive = true

        return instructionsContentView
    }
}

class ContentView: UIView {
    public var infoView: UIView?
    public var referencesView: UIView?
    public var tertiaryInfoView: UIView?
    public var accreditationTimeView: UIView?
    public var actionsView: UIView?
}
