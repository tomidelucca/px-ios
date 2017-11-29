//
//  PXInstructionsReferenceRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsReferenceRenderer: NSObject {
    let CONTENT_WIDTH_PERCENT: CGFloat = 100.0
    let TITLE_LABEL_FONT_SIZE: CGFloat = 12.0
    let TITLE_LABEL_FONT_COLOR: UIColor = .pxBrownishGray
    let REFERENCE_LABEL_FONT_SIZE: CGFloat = 20.0
    let REFERENCE_LABEL_FONT_COLOR: UIColor = .pxBlack

    func render(instructionReference: PXInstructionsReferenceComponent) -> ReferenceView {
        let instructionReferenceView = ReferenceView()
        instructionReferenceView.translatesAutoresizingMaskIntoConstraints = false
        instructionReferenceView.backgroundColor = .pxLightGray
        instructionReferenceView.translatesAutoresizingMaskIntoConstraints = false
        var lastView: UIView?

        if let title = instructionReference.props.reference?.label {
            let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_LABEL_FONT_SIZE) ]
            let attributedString = NSAttributedString(string: title, attributes: attributes)
            instructionReferenceView.titleLabel = buildLabel(with: attributedString, in: instructionReferenceView, onBottomOf: nil, isTitle: true)
            lastView = instructionReferenceView.titleLabel
        }

        if let referenceText = instructionReference.props.reference?.getFullReferenceValue(), referenceText.isNotEmpty {
            let attributes = [ NSFontAttributeName: Utils.getFont(size: REFERENCE_LABEL_FONT_SIZE) ]
            let attributedString = NSAttributedString(string: referenceText, attributes: attributes)
            instructionReferenceView.referenceLabel = buildLabel(with: attributedString, in: instructionReferenceView, onBottomOf: lastView)
            lastView = instructionReferenceView.referenceLabel
        }

        if let lastView = lastView {
            MPLayout.pinBottom(view: lastView, to: instructionReferenceView).isActive = true
        }

        return instructionReferenceView
    }

    func buildLabel(with text: NSAttributedString, in superView: UIView, onBottomOf upperView: UIView?, isTitle: Bool = false) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = text
        label.lineBreakMode = .byWordWrapping
        superView.addSubview(label)
        var textColor: UIColor = REFERENCE_LABEL_FONT_COLOR
        var textSize: CGFloat = REFERENCE_LABEL_FONT_SIZE
        if isTitle {
            textColor = TITLE_LABEL_FONT_COLOR
            textSize = TITLE_LABEL_FONT_SIZE
        }
        label.textColor = textColor

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100

        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
        MPLayout.setHeight(owner: label, height: height).isActive = true
        MPLayout.setWidth(ofView: label, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: label, to: superView).isActive = true

        if let upperView = upperView {
            MPLayout.put(view: label, onBottomOf: upperView, withMargin: MPLayout.XXXS_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: label, to: superView, withMargin: MPLayout.ZERO_MARGIN).isActive = true
        }

        return label
    }
}

class ReferenceView: UIView {
    public var titleLabel: UILabel?
    public var referenceLabel: UILabel?
}
