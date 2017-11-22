//
//  InstructionsContentRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsContentRenderer: NSObject {
    
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

        MPLayout.pinBottom(view: bottomView, to: instructionsContentView).isActive = true

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
