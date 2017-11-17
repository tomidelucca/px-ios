//
//  InstructionsInfoRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsInfoRenderer: NSObject {
    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let TITLE_LABEL_FONT_SIZE: CGFloat = 20.0
    let TITLE_LABEL_FONT_COLOR: UIColor = .pxBlack
    let INFO_LABEL_FONT_SIZE: CGFloat = 16.0
    let INFO_LABEL_FONT_COLOR: UIColor = .pxBrownishGrey
    
    func render(instructionsInfo: InstructionsInfoComponent) -> UIView {
        let instructionsInfoView = InfoView()
        instructionsInfoView.translatesAutoresizingMaskIntoConstraints = false
        instructionsInfoView.backgroundColor = .pxLightGray
        
        
        var lastLabel: UILabel?
        
        if let infoTitle = instructionsInfo.props.infoTitle, !infoTitle.isEmpty {
            let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_LABEL_FONT_SIZE) ]
            let attributedString = NSAttributedString(string: infoTitle, attributes: attributes)
            let isLastLabel = Array.isNullOrEmpty(instructionsInfo.props.infoContent)
            instructionsInfoView.titleLabel = buildInfoLabel(with: attributedString, in: instructionsInfoView, onBottomOf: lastLabel, isLastLabel: isLastLabel, isTitle: true)
            lastLabel = instructionsInfoView.titleLabel
        }
        
        if let infoContent = instructionsInfo.props.infoContent, !Array.isNullOrEmpty(instructionsInfo.props.infoContent) {
            var loopsDone = 0
            for text in infoContent {
                var isLast = false
                
                if loopsDone == infoContent.count - 1 {
                    isLast = true
                }

                let attributes = [ NSFontAttributeName: Utils.getFont(size: INFO_LABEL_FONT_SIZE) ]
                let attributedString = NSAttributedString(string: text, attributes: attributes)
                let infoContentLabel = buildInfoLabel(with: attributedString, in: instructionsInfoView, onBottomOf: lastLabel, isLastLabel: isLast)
                instructionsInfoView.contentLabels?.append(infoContentLabel)
                lastLabel = infoContentLabel
                loopsDone += 1
            }
        }
        
        if instructionsInfo.props.bottomDivider != nil, instructionsInfo.props.bottomDivider == true {
            
        }
        
        return instructionsInfoView
    }
    
    func buildInfoLabel(with text: NSAttributedString, in superView: UIView, onBottomOf upperView: UIView?, isLastLabel: Bool = false, isTitle: Bool = false) -> UILabel {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.attributedText = text
        infoLabel.lineBreakMode = .byWordWrapping
        superView.addSubview(infoLabel)
        var textColor: UIColor = INFO_LABEL_FONT_COLOR
        var textSize: CGFloat = INFO_LABEL_FONT_SIZE
        if isTitle {
            textColor = TITLE_LABEL_FONT_COLOR
            textSize = TITLE_LABEL_FONT_SIZE
        }
        infoLabel.textColor = textColor
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100
        
        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
        MPLayout.setHeight(owner: infoLabel, height: height).isActive = true
        MPLayout.setWidth(ofView: infoLabel, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: infoLabel, to: superView).isActive = true
        if let upperView = upperView {
            MPLayout.put(view: infoLabel, onBottomOf:upperView, withMargin: S_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: infoLabel, to: superView, withMargin: S_MARGIN).isActive = true
        }
        
        if isLastLabel {
            MPLayout.pinBottom(view: infoLabel, to: superView, withMargin: S_MARGIN).isActive = true
        }
        
        return infoLabel
    }
}

class InfoView: UIView {
    public var titleLabel: UILabel?
    public var contentLabels: [UILabel]?
    public var bottomDivider: UIView?
}
