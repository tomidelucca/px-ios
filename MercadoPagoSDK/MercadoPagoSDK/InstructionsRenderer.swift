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
        let instructionsView = UIView()
        instructionsView.translatesAutoresizingMaskIntoConstraints = false
        instructionsView.backgroundColor = .yellow
        
        if instructions.hasSubtitle() {
            let instructionsSubtitleRenderer = InstructionsSubtitleRenderer()
            let instructionsSubtitleView = instructionsSubtitleRenderer.render(instructionsSubtitle: instructions.getSubtitleComponent())
            instructionsSubtitleView.backgroundColor = .purple
            instructionsView.addSubview(instructionsSubtitleView)
            MPLayout.equalizeWidth(view: instructionsSubtitleView, to: instructionsView).isActive = true
            MPLayout.equalizeHeight(view: instructionsSubtitleView, to: instructionsView).isActive = true
            MPLayout.centerHorizontally(view: instructionsSubtitleView, to: instructionsView).isActive = true
            MPLayout.centerVertically(view: instructionsSubtitleView, into: instructionsView).isActive = true
        }

        let instructionsContentRenderer = InstructionsContentRenderer()
        let instructionsContentView = instructionsContentRenderer.render(instructionsContent: instructions.getContentComponent())
        instructionsView.addSubview(instructionsContentView)

        if instructions.hasSecondaryInfo(), instructions.shouldShowEmailInSecondaryInfo() {
            let instructionsSecondaryInfoRenderer = InstructionsSecondaryInfoRenderer()
            let instructionsSecondaryInfoView = instructionsSecondaryInfoRenderer.render(instructionsSecondaryInfo: instructions.getSecondaryInfoComponent())
            instructionsView.addSubview(instructionsSecondaryInfoView)
        }

        return instructionsView
    }
}
