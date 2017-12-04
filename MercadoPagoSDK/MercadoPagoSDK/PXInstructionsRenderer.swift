//
//  PXInstructionsRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsRenderer: NSObject {

    func render(_ instructions: PXInstructionsComponent) -> PXInstructionsView {
        let instructionsView = PXInstructionsView()
        instructionsView.translatesAutoresizingMaskIntoConstraints = false
        var bottomView: UIView!

        //Subtitle Component
        if instructions.hasSubtitle(), let subtitleComponent = instructions.getSubtitleComponent() {
            instructionsView.subtitleView = subtitleComponent.render()
            instructionsView.addSubview(instructionsView.subtitleView!)
            PXLayout.pinTop(view: instructionsView.subtitleView!, to: instructionsView).isActive = true
            PXLayout.equalizeWidth(view: instructionsView.subtitleView!, to: instructionsView).isActive = true
            PXLayout.centerHorizontally(view: instructionsView.subtitleView!, to: instructionsView).isActive = true
        }

        //Content Component
        if let contentComponent = instructions.getContentComponent() {
            instructionsView.contentView = contentComponent.render()
            instructionsView.addSubview(instructionsView.contentView!)
            if let subtitleView = instructionsView.subtitleView {
                PXLayout.put(view: instructionsView.contentView!, onBottomOf: subtitleView).isActive = true
            } else {
                PXLayout.pinTop(view: instructionsView.contentView!, to: instructionsView).isActive = true
            }
            PXLayout.equalizeWidth(view: instructionsView.contentView!, to: instructionsView).isActive = true
            PXLayout.centerHorizontally(view: instructionsView.contentView!, to: instructionsView).isActive = true
            bottomView = instructionsView.contentView!
        }

        //Secondary Info Component
        if instructions.hasSecondaryInfo(), instructions.shouldShowEmailInSecondaryInfo(), let secondaryInfoComponent = instructions.getSecondaryInfoComponent() {
            instructionsView.secondaryInfoView = secondaryInfoComponent.render()
            instructionsView.addSubview(instructionsView.secondaryInfoView!)
            PXLayout.put(view: instructionsView.secondaryInfoView!, onBottomOf: instructionsView.contentView!).isActive = true
            PXLayout.equalizeWidth(view: instructionsView.secondaryInfoView!, to: instructionsView).isActive = true
            PXLayout.centerHorizontally(view: instructionsView.secondaryInfoView!, to: instructionsView).isActive = true
            bottomView = instructionsView.secondaryInfoView!
        }

        if let secondaryInfo = instructionsView.secondaryInfoView {
            PXLayout.put(view: instructionsView.contentView!, aboveOf: secondaryInfo).isActive = true
            PXLayout.pinBottom(view: bottomView, to: instructionsView).isActive = true
        } else {
            PXLayout.pinBottom(view: instructionsView.contentView!, to: instructionsView).isActive = true
        }

        return instructionsView
    }
}

class PXInstructionsView: PXBodyView {
    public var subtitleView: UIView?
    public var contentView: UIView?
    public var secondaryInfoView: UIView?
}
