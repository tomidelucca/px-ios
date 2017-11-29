//
//  PXInstructionsReferencesRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsReferencesRenderer: NSObject {
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let TITLE_LABEL_FONT_SIZE: CGFloat = 20.0
    let TITLE_LABEL_FONT_COLOR: UIColor = .pxBlack

    func render(instructionsReferences: PXInstructionsReferencesComponent) -> UIView {
        let instructionsReferencesView = PXInstructionsReferencesView()
        instructionsReferencesView.translatesAutoresizingMaskIntoConstraints = false
        instructionsReferencesView.backgroundColor = .pxLightGray
        var lastView: UIView?

        if let title = instructionsReferences.props.title, !title.isEmpty {
            let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_LABEL_FONT_SIZE) ]
            let attributedString = NSAttributedString(string: title, attributes: attributes)
            instructionsReferencesView.titleLabel = buildTitleLabel(with: attributedString, in: instructionsReferencesView)
            lastView = instructionsReferencesView.titleLabel
        }
        
        for reference in instructionsReferences.getReferenceComponents() {
            let isFirstView = String.isNullOrEmpty(instructionsReferences.props.title) && instructionsReferencesView.titleLabel == nil
            let referenceView = buildReferenceView(with: reference, in: instructionsReferencesView, onBottomOf: lastView, isFirstView: isFirstView)
            instructionsReferencesView.referencesComponents = Array.safeAppend(instructionsReferencesView.referencesComponents, referenceView)
            lastView = referenceView
        }

        MPLayout.pinLastSubviewToBottom(view: instructionsReferencesView)?.isActive = true

        return instructionsReferencesView
    }

    func buildTitleLabel(with text: NSAttributedString, in superView: UIView) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = text
        titleLabel.lineBreakMode = .byWordWrapping
        superView.addSubview(titleLabel)
        let textSize: CGFloat = TITLE_LABEL_FONT_SIZE
        titleLabel.textColor = TITLE_LABEL_FONT_COLOR

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100

        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
        MPLayout.setHeight(owner: titleLabel, height: height).isActive = true
        MPLayout.setWidth(ofView: titleLabel, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: titleLabel, to: superView).isActive = true
        MPLayout.pinTop(view: titleLabel, to: superView, withMargin: MPLayout.L_MARGIN).isActive = true

        return titleLabel
    }

    func buildReferenceView(with reference: PXInstructionsReferenceComponent, in superView: UIView, onBottomOf upperView: UIView?, isFirstView: Bool = false) -> UIView {

        let referenceView = reference.render()
        superView.addSubview(referenceView)
        MPLayout.setWidth(ofView: referenceView, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: referenceView, to: superView).isActive = true
        if let upperView = upperView {
            MPLayout.put(view: referenceView, onBottomOf: upperView, withMargin: MPLayout.L_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: referenceView, to: superView, withMargin: MPLayout.L_MARGIN).isActive = true
        }

        return referenceView
    }
}

class PXInstructionsReferencesView: UIView {
    public var titleLabel: UILabel?
    public var referencesComponents: [UIView]?
}
