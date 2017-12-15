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
            if let infoView = instructionsContentView.infoView {
                instructionsContentView.addSubview(infoView)
                PXLayout.pinTop(view: infoView, to: instructionsContentView).isActive = true
                PXLayout.centerHorizontally(view: infoView, to: instructionsContentView).isActive = true
                PXLayout.matchWidth(ofView: infoView, toView: instructionsContentView).isActive = true
                bottomView = instructionsContentView.infoView
            }
        }

        if instructionsContent.hasReferences(), let referencesComponent = instructionsContent.getReferencesComponent() {
            instructionsContentView.referencesView = referencesComponent.render()
            if let referencesView = instructionsContentView.referencesView {
                instructionsContentView.addSubview(referencesView)
                if let lastView = bottomView {
                    PXLayout.put(view: referencesView, onBottomOf: lastView).isActive = true
                } else {
                    PXLayout.pinTop(view: referencesView, to: instructionsContentView).isActive = true
                }
                PXLayout.centerHorizontally(view: referencesView, to: instructionsContentView).isActive = true
                PXLayout.matchWidth(ofView: referencesView, toView: instructionsContentView).isActive = true
                bottomView = instructionsContentView.referencesView
            }
        }

        if instructionsContent.hasTertiaryInfo(), let tertiaryInfoComponent = instructionsContent.getTertiaryInfoComponent() {
            instructionsContentView.tertiaryInfoView = tertiaryInfoComponent.render()
            if let tertiaryInfoView = instructionsContentView.tertiaryInfoView {
                instructionsContentView.addSubview(tertiaryInfoView)
                if let lastView = bottomView {
                    PXLayout.put(view: tertiaryInfoView, onBottomOf: lastView).isActive = true
                } else {
                    PXLayout.pinTop(view: tertiaryInfoView, to: instructionsContentView).isActive = true
                }
                PXLayout.centerHorizontally(view: tertiaryInfoView, to: instructionsContentView).isActive = true
                PXLayout.matchWidth(ofView: tertiaryInfoView, toView: instructionsContentView).isActive = true
                bottomView = instructionsContentView.tertiaryInfoView

            }
        }

        if instructionsContent.hasAccreditationTime(), let accreditationTimeComponent = instructionsContent.getAccreditationTimeComponent() {
            instructionsContentView.accreditationTimeView = accreditationTimeComponent.render()
            if let accreditationTimeView = instructionsContentView.accreditationTimeView {
                instructionsContentView.addSubview(accreditationTimeView)
                if let lastView = bottomView {
                    PXLayout.put(view: accreditationTimeView, onBottomOf: lastView).isActive = true
                } else {
                    PXLayout.pinTop(view: accreditationTimeView, to: instructionsContentView).isActive = true
                }
                PXLayout.centerHorizontally(view: accreditationTimeView, to: instructionsContentView).isActive = true
                PXLayout.matchWidth(ofView: accreditationTimeView, toView: instructionsContentView).isActive = true
                bottomView = instructionsContentView.accreditationTimeView
            }
        }
        if instructionsContent.hasActions(), let actionsComponent = instructionsContent.getActionsComponent() {
            instructionsContentView.actionsView = actionsComponent.render()
            if let actionsView = instructionsContentView.actionsView {
                instructionsContentView.addSubview(actionsView)
                if let lastView = bottomView {
                    PXLayout.put(view: actionsView, onBottomOf: lastView).isActive = true
                } else {
                    PXLayout.pinTop(view: actionsView, to: instructionsContentView).isActive = true
                }
                PXLayout.centerHorizontally(view: actionsView, to: instructionsContentView).isActive = true
                PXLayout.matchWidth(ofView: actionsView, toView: instructionsContentView).isActive = true
                bottomView = instructionsContentView.actionsView
            }
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
