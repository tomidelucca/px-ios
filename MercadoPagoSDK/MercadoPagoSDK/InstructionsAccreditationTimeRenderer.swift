//
//  InstructionsAccreditationTimeRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsAccreditationTimeRenderer: NSObject {
    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 30.0
    let M_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let XS_MARGIN: CGFloat = 10.0
    let XXS_MARGIN: CGFloat = 5.0
    let ZERO_MARGIN: CGFloat = 0.0
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let ACCREDITATION_LABEL_FONT_SIZE: CGFloat = 12.0
    let ACCREDITATION_LABEL_FONT_COLOR: UIColor = .pxBrownishGray
    
    func render(instructionsAccreditationTime: InstructionsAccreditationTimeComponent) -> UIView {
        let instructionsAccreditationTimeView = AccreditationTimeView()
        instructionsAccreditationTimeView.translatesAutoresizingMaskIntoConstraints = false
        instructionsAccreditationTimeView.backgroundColor = .pxLightGray
        var lastView: UIView?
        
        if let title = instructionsAccreditationTime.props.accreditationMessage, !title.isEmpty {
            instructionsAccreditationTimeView.accreditationMessageLabel = buildTitleLabel(with: title, in: instructionsAccreditationTimeView)
            lastView = instructionsAccreditationTimeView.accreditationMessageLabel
        }
        
        if let commentsArray = instructionsAccreditationTime.props.accreditationComments, !Array.isNullOrEmpty(commentsArray) {
            var loopsDone = 0
            for comment in commentsArray {
                let commentView = buildCommentView(with: comment, in: instructionsAccreditationTimeView, onBottomOf: lastView)
                instructionsAccreditationTimeView.accreditationCommentsComponents?.append(commentView)
                lastView = commentView
                loopsDone += 1
            }
        }
        
        if let lastView = lastView {
            MPLayout.pinBottom(view: lastView, to: instructionsAccreditationTimeView).isActive = true
        }
        
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
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100
        
        let height = UILabel.requiredHeight(forAttributedText: labelTitle, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
        MPLayout.setHeight(owner: titleLabel, height: height).isActive = true
        MPLayout.setWidth(ofView: titleLabel, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: titleLabel, to: superView).isActive = true
        MPLayout.pinTop(view: titleLabel, to: superView, withMargin: L_MARGIN).isActive = true
        
        return titleLabel
    }
    
    func buildCommentView(with comment: String, in superView: UIView, onBottomOf upperView: UIView?) -> UIView {
        let accreditationCommentRenderer = InstructionsAccreditationCommentRenderer()
        let accreditationCommentProps = InstructionsAccreditationCommentProps(accreditationComment: comment)
        let accreditationCommentComponent = InstructionsAccreditationCommentComponent(props: accreditationCommentProps)
        let accreditationCommentView = accreditationCommentRenderer.render(instructionsAccreditationComment: accreditationCommentComponent)
        superView.addSubview(accreditationCommentView)
        MPLayout.setWidth(ofView: accreditationCommentView, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: accreditationCommentView, to: superView).isActive = true
        if let upperView = upperView {
            MPLayout.put(view: accreditationCommentView, onBottomOf: upperView, withMargin: XS_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: accreditationCommentView, to: superView, withMargin: L_MARGIN).isActive = true
        }
        
        return accreditationCommentView
    }
}

class AccreditationTimeView: UIView {
    public var accreditationMessageLabel: UILabel?
    public var accreditationCommentsComponents: [UIView]?
}

