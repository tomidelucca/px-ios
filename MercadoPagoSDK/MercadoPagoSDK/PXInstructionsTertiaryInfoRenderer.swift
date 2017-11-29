//
//  PXInstructionsTertiaryInfoRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsTertiaryInfoRenderer: NSObject {
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let TITLE_LABEL_FONT_SIZE: CGFloat = 20.0
    let TITLE_LABEL_FONT_COLOR: UIColor = .pxBlack
    let INFO_LABEL_FONT_SIZE: CGFloat = 12.0
    let INFO_LABEL_FONT_COLOR: UIColor = .pxBrownishGray

    func render(_ instructionsTertiaryInfo: PXInstructionsTertiaryInfoComponent) -> PXInstructionsTertiaryInfoView {
        let instructionsTertiaryInfoView = PXInstructionsTertiaryInfoView()
        instructionsTertiaryInfoView.translatesAutoresizingMaskIntoConstraints = false
        instructionsTertiaryInfoView.backgroundColor = .pxLightGray

        var lastLabel: UILabel?

        if let tertiaryInfoContent = instructionsTertiaryInfo.props.tertiaryInfo, !Array.isNullOrEmpty(instructionsTertiaryInfo.props.tertiaryInfo) {
            for text in tertiaryInfoContent {

                let attributes = [ NSFontAttributeName: Utils.getFont(size: INFO_LABEL_FONT_SIZE) ]
                let attributedString = NSAttributedString(string: text, attributes: attributes)
                let infoContentLabel = buildInfoLabel(with: attributedString, in: instructionsTertiaryInfoView, onBottomOf: lastLabel)
                instructionsTertiaryInfoView.tertiaryInfoLabels = Array.safeAppend(instructionsTertiaryInfoView.tertiaryInfoLabels, infoContentLabel)
                lastLabel = infoContentLabel
            }
        }

        MPLayout.pinLastSubviewToBottom(view: instructionsTertiaryInfoView)?.isActive = true

        return instructionsTertiaryInfoView
    }

    func buildInfoLabel(with text: NSAttributedString, in superView: UIView, onBottomOf upperView: UIView?) -> UILabel {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.attributedText = text
        infoLabel.lineBreakMode = .byWordWrapping
        superView.addSubview(infoLabel)
        let textSize: CGFloat = INFO_LABEL_FONT_SIZE
        infoLabel.textColor = INFO_LABEL_FONT_COLOR

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100

        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
        MPLayout.setHeight(owner: infoLabel, height: height).isActive = true
        MPLayout.setWidth(ofView: infoLabel, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: infoLabel, to: superView).isActive = true
        if let upperView = upperView {
            MPLayout.put(view: infoLabel, onBottomOf:upperView, withMargin: MPLayout.XXS_MARGIN).isActive = true
        } else {
            MPLayout.pinTop(view: infoLabel, to: superView, withMargin: MPLayout.L_MARGIN).isActive = true
        }

        return infoLabel
    }
}

class PXInstructionsTertiaryInfoView: UIView {
    public var tertiaryInfoLabels: [UILabel]?
}
