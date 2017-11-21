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
    let L_MARGIN: CGFloat = 30.0
    let M_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let ZERO_MARGIN: CGFloat = 0.0
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
                let isFirstInfo = loopsDone == 0
                let infoContentLabel = buildInfoLabel(with: attributedString, in: instructionsInfoView, onBottomOf: lastLabel, isLastLabel: isLast, bottomDivider: instructionsInfo.props.bottomDivider, isFirstInfo: isFirstInfo)
                instructionsInfoView.contentLabels?.append(infoContentLabel)
                lastLabel = infoContentLabel
                loopsDone += 1
            }
        }
        
        if instructionsInfo.props.bottomDivider != nil, instructionsInfo.props.bottomDivider == true {
            instructionsInfoView.bottomDivider = buildBottomDivider(in: instructionsInfoView, onBottomOf: lastLabel)
        }
        
        return instructionsInfoView
    }
    
    func buildInfoLabel(with text: NSAttributedString, in superView: UIView, onBottomOf upperView: UIView?, isLastLabel: Bool = false, isTitle: Bool = false, bottomDivider: Bool? = false, isFirstInfo: Bool = false) -> UILabel {
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
            if isFirstInfo {
                MPLayout.put(view: infoLabel, onBottomOf:upperView, withMargin: L_MARGIN).isActive = true
            } else {
                MPLayout.put(view: infoLabel, onBottomOf:upperView, withMargin: ZERO_MARGIN).isActive = true
            }
        } else {
            MPLayout.pinTop(view: infoLabel, to: superView, withMargin: L_MARGIN).isActive = true
        }
        
        if isLastLabel, !bottomDivider! {
            MPLayout.pinBottom(view: infoLabel, to: superView).isActive = true
        }
        
        return infoLabel
    }
    
    func buildBottomDivider(in superView: UIView, onBottomOf upperView: UIView?) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let view = UIView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .pxMediumLightGrey
        superView.addSubview(view)
        MPLayout.setHeight(owner: view, height: 1).isActive = true
        MPLayout.setWidth(ofView: view, asWidthOfView: superView).isActive = true
        MPLayout.centerHorizontally(view: view, to: superView).isActive = true
        
        if let upperView = upperView {
            MPLayout.put(view: view, onBottomOf:upperView, withMargin: L_MARGIN).isActive = true
        }
        
        MPLayout.pinBottom(view: view, to: superView).isActive = true
        return view
    }
}

class InfoView: UIView {
    public var titleLabel: UILabel?
    public var contentLabels: [UILabel]?
    public var bottomDivider: UIView?
}
