//
//  InstructionsReferencesRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsReferencesRenderer: NSObject {
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
    
    func render(instructionsReferences: InstructionsReferencesComponent) -> UIView {
        let instructionsReferencesView = ReferencesView()
        instructionsReferencesView.translatesAutoresizingMaskIntoConstraints = false
        instructionsReferencesView.backgroundColor = .pxLightGray
        var lastLabel: UILabel?
        
        if let title = instructionsReferences.props.title, !title.isEmpty {
            let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_LABEL_FONT_SIZE) ]
            let attributedString = NSAttributedString(string: title, attributes: attributes)
//            let isLastLabel = Array.isNullOrEmpty(instructionsReferences.props.infoContent)
            instructionsReferencesView.titleLabel = buildInfoLabel(with: attributedString, in: instructionsReferencesView, onBottomOf: lastLabel, isTitle: true)
            lastLabel = instructionsReferencesView.titleLabel
        }
        
        if let referencesArray = instructionsReferences.props.references, !Array.isNullOrEmpty(referencesArray) {
            var loopsDone = 0
            for reference in referencesArray {
                var isLast = false
                if loopsDone == referencesArray.count - 1 {
                    isLast = true
                }
                loopsDone += 1
                
                let referenceRenderer = InstructionReferenceRenderer()
                let referenceProps = InstructionReferenceProps(reference: reference)
                let referenceComponent = InstructionReferenceComponent(props: referenceProps)
                let referenceView = referenceRenderer.render(instructionReference: referenceComponent)
                MPLayout.setWidth(ofView: referenceView, asWidthOfView: instructionsReferencesView).isActive = true
                MPLayout.centerHorizontally(view: referenceView, to: instructionsReferencesView).isActive = true
            }
        }
        
        return instructionsReferencesView
    }
    
    func buildInfoLabel(with text: NSAttributedString, in superView: UIView, onBottomOf upperView: UIView?, isLastLabel: Bool = false, isTitle: Bool = false, bottomDivider: Bool? = false, isFirstInfo: Bool = false) -> UILabel {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .center
//        infoLabel.numberOfLines = 0
//        infoLabel.attributedText = text
//        infoLabel.lineBreakMode = .byWordWrapping
//        superView.addSubview(infoLabel)
//        var textColor: UIColor = INFO_LABEL_FONT_COLOR
//        var textSize: CGFloat = INFO_LABEL_FONT_SIZE
//        if isTitle {
//            textColor = TITLE_LABEL_FONT_COLOR
//            textSize = TITLE_LABEL_FONT_SIZE
//        }
//        infoLabel.textColor = textColor
//
//        let screenSize = UIScreen.main.bounds
//        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100
//
//        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
//        MPLayout.setHeight(owner: infoLabel, height: height).isActive = true
//        MPLayout.setWidth(ofView: infoLabel, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
//        MPLayout.centerHorizontally(view: infoLabel, to: superView).isActive = true
//        if let upperView = upperView {
//            if isFirstInfo {
//                MPLayout.put(view: infoLabel, onBottomOf:upperView, withMargin: L_MARGIN).isActive = true
//            } else {
//                MPLayout.put(view: infoLabel, onBottomOf:upperView, withMargin: ZERO_MARGIN).isActive = true
//            }
//        } else {
//            MPLayout.pinTop(view: infoLabel, to: superView, withMargin: L_MARGIN).isActive = true
//        }
//
//        if isLastLabel, !bottomDivider! {
//            MPLayout.pinBottom(view: infoLabel, to: superView).isActive = true
//        }
        
        return infoLabel
    }
}

class ReferencesView: UIView {
    public var titleLabel: UILabel?
    public var referencesComponents: [UIView]?
}
