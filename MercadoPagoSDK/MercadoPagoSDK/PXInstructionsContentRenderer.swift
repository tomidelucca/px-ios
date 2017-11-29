//
//  PXInstructionsContentRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsContentRenderer: NSObject {

    func render(_ instructionsContent: PXInstructionsContentComponent) -> PXInstructionsContentView {
        let instructionsContentView = PXInstructionsContentView()
        instructionsContentView.translatesAutoresizingMaskIntoConstraints = false
        instructionsContentView.backgroundColor = .pxLightGray
        var bottomView: UIView!

        if instructionsContent.hasInfo(), let infoComponent = instructionsContent.getInfoComponent() {
            instructionsContentView.infoView = infoComponent.render()
            instructionsContentView.addSubview(instructionsContentView.infoView!)
            PXLayout.pinTop(view: instructionsContentView.infoView!, to: instructionsContentView).isActive = true
            PXLayout.centerHorizontally(view: instructionsContentView.infoView!, to: instructionsContentView).isActive = true
            PXLayout.equalizeWidth(view: instructionsContentView.infoView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.infoView
        }

        if instructionsContent.hasReferences(), let referencesComponent = instructionsContent.getReferencesComponent() {
            instructionsContentView.referencesView = referencesComponent.render()
            instructionsContentView.addSubview(instructionsContentView.referencesView!)
            if let lastView = bottomView {
                PXLayout.put(view: instructionsContentView.referencesView!, onBottomOf: lastView).isActive = true
            } else {
                PXLayout.pinTop(view: instructionsContentView.referencesView!, to: instructionsContentView).isActive = true
            }

            PXLayout.centerHorizontally(view: instructionsContentView.referencesView!, to: instructionsContentView).isActive = true
            PXLayout.equalizeWidth(view: instructionsContentView.referencesView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.referencesView
        }

        if instructionsContent.hasTertiaryInfo(), let tertiaryInfoComponent = instructionsContent.getTertiaryInfoComponent() {
            instructionsContentView.tertiaryInfoView = tertiaryInfoComponent.render()
            instructionsContentView.addSubview(instructionsContentView.tertiaryInfoView!)
            if let lastView = bottomView {
                PXLayout.put(view: instructionsContentView.tertiaryInfoView!, onBottomOf: lastView).isActive = true
            } else {
                PXLayout.pinTop(view: instructionsContentView.tertiaryInfoView!, to: instructionsContentView).isActive = true
            }
            PXLayout.centerHorizontally(view: instructionsContentView.tertiaryInfoView!, to: instructionsContentView).isActive = true
            PXLayout.equalizeWidth(view: instructionsContentView.tertiaryInfoView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.tertiaryInfoView
        }

        if instructionsContent.hasAccreditationTime(), let accreditationTimeComponent = instructionsContent.getAccreditationTimeComponent() {
            instructionsContentView.accreditationTimeView = accreditationTimeComponent.render()
            instructionsContentView.addSubview(instructionsContentView.accreditationTimeView!)
            if let lastView = bottomView {
                PXLayout.put(view: instructionsContentView.accreditationTimeView!, onBottomOf: lastView).isActive = true
            } else {
                PXLayout.pinTop(view: instructionsContentView.accreditationTimeView!, to: instructionsContentView).isActive = true
            }

            PXLayout.centerHorizontally(view: instructionsContentView.accreditationTimeView!, to: instructionsContentView).isActive = true
            PXLayout.equalizeWidth(view: instructionsContentView.accreditationTimeView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.accreditationTimeView
        }
        if instructionsContent.hasActions(), let actionsComponent = instructionsContent.getActionsComponent() {
            instructionsContentView.actionsView = actionsComponent.render()
            instructionsContentView.addSubview(instructionsContentView.actionsView!)
            if let lastView = bottomView {
                PXLayout.put(view: instructionsContentView.actionsView!, onBottomOf: lastView).isActive = true
            } else {
                PXLayout.pinTop(view: instructionsContentView.actionsView!, to: instructionsContentView).isActive = true
            }

            PXLayout.centerHorizontally(view: instructionsContentView.actionsView!, to: instructionsContentView).isActive = true
            PXLayout.equalizeWidth(view: instructionsContentView.actionsView!, to: instructionsContentView).isActive = true
            bottomView = instructionsContentView.actionsView
        }

        PXLayout.pinBottom(view: bottomView, to: instructionsContentView, withMargin: PXLayout.L_MARGIN).isActive = true

        return instructionsContentView
    }
}

class PXInstructionsContentView: UIView {
    public var infoView: UIView?
    public var referencesView: UIView?
    public var tertiaryInfoView: UIView?
    public var accreditationTimeView: UIView?
    public var actionsView: UIView?
}
