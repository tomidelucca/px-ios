//
//  InstructionsSecondaryInfoRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsSecondaryInfoRenderer: NSObject {
    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let LABEL_FONT_SIZE: CGFloat = 12.0

    func render(instructionsSecondaryInfo: InstructionsSecondaryInfoComponent) -> UIView {
        let instructionsSecondaryInfoView = SecondaryInfoView()
        instructionsSecondaryInfoView.translatesAutoresizingMaskIntoConstraints = false
        instructionsSecondaryInfoView.backgroundColor = .pxWhite

        var lastLabel: UILabel?
        var loopsDone = 0
        for string in instructionsSecondaryInfo.props.secondaryInfo {
            var isLast = false
            
            if loopsDone == instructionsSecondaryInfo.props.secondaryInfo.count - 1 {
                isLast = true
            }
            
            let attributes = [ NSFontAttributeName: Utils.getFont(size: LABEL_FONT_SIZE) ]
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            let secondaryInfoLabel = buildSecondaryInfoLabel(with: attributedString, in: instructionsSecondaryInfoView, onBottomOf: lastLabel, isLastLabel: isLast)
            instructionsSecondaryInfoView.secondaryInfoLabels?.append(secondaryInfoLabel)
            lastLabel = secondaryInfoLabel
            loopsDone += 1
        }

        return instructionsSecondaryInfoView
    }
    
    func buildSecondaryInfoLabel(with text: NSAttributedString, in superView: UIView, onBottomOf upperView: UIView?, isLastLabel: Bool = false) -> UILabel {
        let secondaryInfoLabel = UILabel()
        secondaryInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryInfoLabel.textAlignment = .center
        secondaryInfoLabel.textColor = .pxBrownishGrey
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
            MPLayout.put(view: secondaryInfoLabel, onBottomOf:upperView, withMargin: S_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: secondaryInfoLabel, to: superView, withMargin: S_MARGIN).isActive = true
        }
        
        if isLastLabel {
            MPLayout.pinBottom(view: secondaryInfoLabel, to: superView, withMargin: S_MARGIN).isActive = true
        }
        
        return secondaryInfoLabel
    }
}

class SecondaryInfoView: UIView {
    public var secondaryInfoLabels: [UILabel]?
}
