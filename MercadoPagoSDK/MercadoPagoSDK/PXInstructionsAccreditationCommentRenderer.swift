//
//  PXInstructionsAccreditationCommentRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsAccreditationCommentRenderer: NSObject {
    let CONTENT_WIDTH_PERCENT: CGFloat = 100.0
    let ACCREDITATION_LABEL_FONT_SIZE: CGFloat = 12.0
    let ACCREDITATION_LABEL_FONT_COLOR: UIColor = .pxBrownishGray

    func render(_ instructionsAccreditationComment: PXInstructionsAccreditationCommentComponent) -> PXInstructionsAccreditationCommentView {
        let instructionsAccreditationCommentView = PXInstructionsAccreditationCommentView()
        instructionsAccreditationCommentView.translatesAutoresizingMaskIntoConstraints = false
        instructionsAccreditationCommentView.backgroundColor = .pxLightGray

        if let comment = instructionsAccreditationComment.props.accreditationComment {
            let attributes = [ NSFontAttributeName: Utils.getFont(size: ACCREDITATION_LABEL_FONT_SIZE) ]
            let attributedString = NSAttributedString(string: comment, attributes: attributes)
            instructionsAccreditationCommentView.commentLabel = buildLabel(with: attributedString, in: instructionsAccreditationCommentView)
        }
        return instructionsAccreditationCommentView
    }

    func buildLabel(with text: NSAttributedString, in superView: UIView) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = text
        label.lineBreakMode = .byWordWrapping
        superView.addSubview(label)
        let textColor: UIColor = ACCREDITATION_LABEL_FONT_COLOR
        let textSize: CGFloat = ACCREDITATION_LABEL_FONT_SIZE
        label.textColor = textColor

        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)

        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
        PXLayout.setHeight(owner: label, height: height).isActive = true
        PXLayout.matchWidth(ofView: label, toView: superView, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        PXLayout.centerHorizontally(view: label, to: superView).isActive = true
        PXLayout.pinTop(view: label, to: superView).isActive = true
        PXLayout.pinBottom(view: label, to: superView).isActive = true

        return label
    }
}

class PXInstructionsAccreditationCommentView: UIView {
    public var commentLabel: UILabel?
}
