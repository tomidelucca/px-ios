//
//  InstructionsRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsRenderer: NSObject {

    
    func render(instructions: PXInstructionsComponent) -> InstructionsView {
        let instructionsView = InstructionsView()
        instructionsView.translatesAutoresizingMaskIntoConstraints = false
        var bottomView: UIView!

        //Subtitle Component
        if instructions.hasSubtitle(), let subtitleComponent = instructions.getSubtitleComponent() {
            instructionsView.subtitleView = subtitleComponent.render()
            instructionsView.addSubview(instructionsView.subtitleView!)
            MPLayout.pinTop(view: instructionsView.subtitleView!, to: instructionsView).isActive = true
            MPLayout.equalizeWidth(view: instructionsView.subtitleView!, to: instructionsView).isActive = true
            MPLayout.centerHorizontally(view: instructionsView.subtitleView!, to: instructionsView).isActive = true
        }

        //Content Component
        if let contentComponent = instructions.getContentComponent() {
            instructionsView.contentView = contentComponent.render()
            instructionsView.addSubview(instructionsView.contentView!)
            if let subtitleView = instructionsView.subtitleView {
                MPLayout.put(view: instructionsView.contentView!, onBottomOf: subtitleView).isActive = true
            } else {
                MPLayout.pinTop(view: instructionsView.contentView!, to: instructionsView).isActive = true
            }
            MPLayout.equalizeWidth(view: instructionsView.contentView!, to: instructionsView).isActive = true
            MPLayout.centerHorizontally(view: instructionsView.contentView!, to: instructionsView).isActive = true
            bottomView = instructionsView.contentView!
        }

        //Secondary Info Component
        if instructions.hasSecondaryInfo(), instructions.shouldShowEmailInSecondaryInfo(), let secondaryInfoComponent = instructions.getSecondaryInfoComponent() {
            instructionsView.secondaryInfoView = secondaryInfoComponent.render()
            instructionsView.addSubview(instructionsView.secondaryInfoView!)
            MPLayout.put(view: instructionsView.secondaryInfoView!, onBottomOf: instructionsView.contentView!).isActive = true
            MPLayout.equalizeWidth(view: instructionsView.secondaryInfoView!, to: instructionsView).isActive = true
            MPLayout.centerHorizontally(view: instructionsView.secondaryInfoView!, to: instructionsView).isActive = true
            bottomView = instructionsView.secondaryInfoView!
        }

        if let secondaryInfo = instructionsView.secondaryInfoView {
            MPLayout.put(view: instructionsView.contentView!, aboveOf: secondaryInfo).isActive = true
            MPLayout.pinBottom(view: bottomView, to: instructionsView).isActive = true
        } else {
            MPLayout.pinBottom(view: instructionsView.contentView!, to: instructionsView).isActive = true
        }

        return instructionsView
    }
}


class InstructionsView: PXBodyView {
    public var subtitleView: UIView?
    public var contentView: UIView?
    public var secondaryInfoView: UIView?
}
