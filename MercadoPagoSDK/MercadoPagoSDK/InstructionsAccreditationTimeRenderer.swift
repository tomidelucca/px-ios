//
//  InstructionsAccreditationTimeRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsAccreditationTimeRenderer: NSObject {
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
        
        for comment in instructionsAccreditationTime.getAccreditationCommentComponents() {
            let commentView = buildCommentView(with: comment, in: instructionsAccreditationTimeView, onBottomOf: lastView)
            instructionsAccreditationTimeView.accreditationCommentsComponents = Array.safeAppend(instructionsAccreditationTimeView.accreditationCommentsComponents, commentView)
            lastView = commentView
        }
        
        MPLayout.pinLastSubviewToBottom(view: instructionsAccreditationTimeView)?.isActive = true
        
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
        MPLayout.pinTop(view: titleLabel, to: superView, withMargin: MPLayout.L_MARGIN).isActive = true
        
        return titleLabel
    }
    
    func buildCommentView(with comment: InstructionsAccreditationCommentComponent, in superView: UIView, onBottomOf upperView: UIView?) -> UIView {
        let accreditationCommentView = comment.render()
        superView.addSubview(accreditationCommentView)
        MPLayout.setWidth(ofView: accreditationCommentView, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: accreditationCommentView, to: superView).isActive = true
        if let upperView = upperView {
            MPLayout.put(view: accreditationCommentView, onBottomOf: upperView, withMargin: MPLayout.XXS_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: accreditationCommentView, to: superView, withMargin: MPLayout.L_MARGIN).isActive = true
        }
        
        return accreditationCommentView
    }
}

class AccreditationTimeView: UIView {
    public var accreditationMessageLabel: UILabel?
    public var accreditationCommentsComponents: [UIView]?
}

