//
//  InstructionsSecondaryInfoRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsSecondaryInfoRenderer: NSObject {
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let LABEL_FONT_SIZE: CGFloat = 12.0

    func render(instructionsSecondaryInfo: InstructionsSecondaryInfoComponent) -> UIView {
        let instructionsSecondaryInfoView = SecondaryInfoView()
        instructionsSecondaryInfoView.translatesAutoresizingMaskIntoConstraints = false
        instructionsSecondaryInfoView.backgroundColor = .pxWhite

        var lastLabel: UILabel?
        for string in instructionsSecondaryInfo.props.secondaryInfo {
            let attributes = [ NSFontAttributeName: Utils.getFont(size: LABEL_FONT_SIZE) ]
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            let secondaryInfoLabel = buildSecondaryInfoLabel(with: attributedString, in: instructionsSecondaryInfoView, onBottomOf: lastLabel)
            instructionsSecondaryInfoView.secondaryInfoLabels?.append(secondaryInfoLabel)
            lastLabel = secondaryInfoLabel
        }

        MPLayout.pinLastSubviewToBottom(view: instructionsSecondaryInfoView, withMargin: MPLayout.S_MARGIN)?.isActive = true

        return instructionsSecondaryInfoView
    }

    func buildSecondaryInfoLabel(with text: NSAttributedString, in superView: UIView, onBottomOf upperView: UIView?) -> UILabel {
        let secondaryInfoLabel = UILabel()
        secondaryInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryInfoLabel.textAlignment = .center
        secondaryInfoLabel.textColor = .pxBrownishGray
        secondaryInfoLabel.numberOfLines = 0
        secondaryInfoLabel.attributedText = text
        secondaryInfoLabel.lineBreakMode = .byWordWrapping
        superView.addSubview(secondaryInfoLabel)

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100

        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: LABEL_FONT_SIZE), inWidth: screenWidth)
        MPLayout.setHeight(owner: secondaryInfoLabel, height: height).isActive = true
        MPLayout.setWidth(ofView: secondaryInfoLabel, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: secondaryInfoLabel, to: superView).isActive = true
        if let upperView = upperView {
            MPLayout.put(view: secondaryInfoLabel, onBottomOf:upperView, withMargin: MPLayout.S_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: secondaryInfoLabel, to: superView, withMargin: MPLayout.S_MARGIN).isActive = true
        }

        return secondaryInfoLabel
    }
}

class SecondaryInfoView: UIView {
    public var secondaryInfoLabels: [UILabel]?
}
