//
//  InstructionsAccreditationCommentRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsAccreditationCommentRenderer: NSObject {
    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 30.0
    let M_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let ZERO_MARGIN: CGFloat = 0.0
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let ACCREDITATION_LABEL_FONT_SIZE: CGFloat = 12.0
    let ACCREDITATION_LABEL_FONT_COLOR: UIColor = .pxBrownishGray
    
    func render(instructionsAccreditationComment: InstructionsAccreditationCommentComponent) -> UIView {
        let instructionsAccreditationCommentView = AccreditationCommentView()
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
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100
        
        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
        MPLayout.setHeight(owner: label, height: height).isActive = true
        MPLayout.setWidth(ofView: label, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: label, to: superView).isActive = true
        MPLayout.pinTop(view: label, to: superView).isActive = true
        MPLayout.pinBottom(view: label, to: superView).isActive = true
        
        return label
    }
}

class AccreditationCommentView: UIView {
    public var commentLabel: UILabel?
}
