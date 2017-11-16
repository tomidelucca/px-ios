//
//  InstructionsRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsRenderer: NSObject {
    
    func render(instructions: InstructionsComponent) -> UIView {
        let instructionsView = InstructionsView()
        instructionsView.translatesAutoresizingMaskIntoConstraints = false
        instructionsView.backgroundColor = .yellow
        var bottomView: UIView!

        if instructions.hasSubtitle() {
            let instructionsSubtitleRenderer = InstructionsSubtitleRenderer()
            instructionsView.subtitleView = instructionsSubtitleRenderer.render(instructionsSubtitle: instructions.getSubtitleComponent())
            instructionsView.addSubview(instructionsView.subtitleView!)
            MPLayout.pinTop(view: instructionsView.subtitleView!, to: instructionsView).isActive = true
            MPLayout.equalizeWidth(view: instructionsView.subtitleView!, to: instructionsView).isActive = true
            MPLayout.centerHorizontally(view: instructionsView.subtitleView!, to: instructionsView).isActive = true
        }

        let instructionsContentRenderer = InstructionsContentRenderer()
        instructionsView.contentView = instructionsContentRenderer.render(instructionsContent: instructions.getContentComponent())
        instructionsView.contentView!.backgroundColor = .brown
        instructionsView.addSubview(instructionsView.contentView!)
        if let subtitleView = instructionsView.subtitleView {
          MPLayout.put(view: instructionsView.contentView!, onBottomOf: subtitleView).isActive = true
        } else {
          MPLayout.pinTop(view: instructionsView.contentView!, to: instructionsView).isActive = true
        }
        MPLayout.equalizeWidth(view: instructionsView.contentView!, to: instructionsView).isActive = true
        MPLayout.centerHorizontally(view: instructionsView.contentView!, to: instructionsView).isActive = true
        MPLayout.setHeight(owner: instructionsView.contentView!, height: 100).isActive = true
        bottomView = instructionsView.contentView!
        
        if instructions.hasSecondaryInfo(), instructions.shouldShowEmailInSecondaryInfo() {
            let instructionsSecondaryInfoRenderer = InstructionsSecondaryInfoRenderer()
            instructionsView.secondaryInfoView = instructionsSecondaryInfoRenderer.render(instructionsSecondaryInfo: instructions.getSecondaryInfoComponent())
            instructionsView.addSubview(instructionsView.secondaryInfoView!)
            MPLayout.put(view: instructionsView.secondaryInfoView!, onBottomOf: instructionsView.contentView!).isActive = true
            MPLayout.equalizeWidth(view: instructionsView.secondaryInfoView!, to: instructionsView).isActive = true
            MPLayout.centerHorizontally(view: instructionsView.secondaryInfoView!, to: instructionsView).isActive = true
            bottomView = instructionsView.secondaryInfoView!
        }
        
        MPLayout.pinBottom(view: bottomView, to: instructionsView).isActive = true
        return instructionsView
    }
}

class InstructionsView: UIView {
    public var subtitleView: UIView?
    public var contentView: UIView?
    public var secondaryInfoView: UIView?
}
