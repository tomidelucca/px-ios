//
//  PXInstructionsAccreditationTimeRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsAccreditationTimeRenderer: NSObject {
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let ACCREDITATION_LABEL_FONT_SIZE: CGFloat = 12.0
    let ACCREDITATION_LABEL_FONT_COLOR: UIColor = .pxBrownishGray

    func render(_ instructionsAccreditationTime: PXInstructionsAccreditationTimeComponent) -> PXInstructionsAccreditationTimeView {
        let instructionsAccreditationTimeView = PXInstructionsAccreditationTimeView()
        instructionsAccreditationTimeView.translatesAutoresizingMaskIntoConstraints = false
        instructionsAccreditationTimeView.backgroundColor = .pxLightGray
        var lastView: UIView?

        if let title = instructionsAccreditationTime.props.accreditationMessage, !title.isEmpty {
            instructionsAccreditationTimeView.accreditationMessageLabel = buildTitleLabel(with: title, in: instructionsAccreditationTimeView)
            lastView = instructionsAccreditationTimeView.accreditationMessageLabel
        }
        for comment in instructionsAccreditationTime.getAccreditationCommentComponents() {
            let commentView = buildCommentView(with: comment, in: instructionsAccreditationTimeView, onBottomOf: lastView)
            instructionsAccreditationTimeView.accreditationCommentsComponents = Array.safeAppend(instructionsAccreditationTimeView.accreditationCommentsComponents, commentView)
            lastView = commentView
        }

        instructionsAccreditationTimeView.pinLastSubviewToBottom()?.isActive = true

        return instructionsAccreditationTimeView
    }

    func buildTitleLabel(with text: String, in superView: UIView) -> UILabel {
        let textSize: CGFloat = ACCREDITATION_LABEL_FONT_SIZE
        let attributes = [ NSFontAttributeName: Utils.getFont(size: textSize) ]
        let clockImage = NSTextAttachment()
        clockImage.image = MercadoPago.getImage("iconTime")
        let clockAttributedString = NSAttributedString(attachment: clockImage)
        let labelAttributedString = NSMutableAttributedString(string: String(describing: " "+text), attributes: attributes)
        labelAttributedString.insert(clockAttributedString, at: 0)
        let labelTitle = labelAttributedString

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = labelTitle
        titleLabel.lineBreakMode = .byWordWrapping
        superView.addSubview(titleLabel)
        titleLabel.textColor = ACCREDITATION_LABEL_FONT_COLOR

        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)

        let height = UILabel.requiredHeight(forAttributedText: labelTitle, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
        PXLayout.setHeight(owner: titleLabel, height: height).isActive = true
        PXLayout.matchWidth(ofView: titleLabel, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        PXLayout.centerHorizontally(view: titleLabel).isActive = true
        PXLayout.pinTop(view: titleLabel, withMargin: PXLayout.L_MARGIN).isActive = true

        return titleLabel
    }

    func buildCommentView(with comment: PXInstructionsAccreditationCommentComponent, in superView: UIView, onBottomOf upperView: UIView?) -> UIView {
        let accreditationCommentView = comment.render()
        superView.addSubview(accreditationCommentView)
        PXLayout.matchWidth(ofView: accreditationCommentView, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        PXLayout.centerHorizontally(view: accreditationCommentView).isActive = true
        if let upperView = upperView {
            PXLayout.put(view: accreditationCommentView, onBottomOf: upperView, withMargin: PXLayout.XXS_MARGIN).isActive = true
        } else {
            PXLayout.pinTop(view: accreditationCommentView, withMargin: PXLayout.L_MARGIN).isActive = true
        }

        return accreditationCommentView
    }
}

class PXInstructionsAccreditationTimeView: PXComponentView {
    public var accreditationMessageLabel: UILabel?
    public var accreditationCommentsComponents: [UIView]?
}
