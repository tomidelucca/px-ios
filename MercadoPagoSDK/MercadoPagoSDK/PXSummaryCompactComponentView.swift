//
//  PXSummaryCompactComponentView.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 2/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

class PXSummaryCompactComponentView: PXComponentView {
    
    fileprivate let TOP_BOTTOM_MARGIN: CGFloat = PXLayout.L_MARGIN * 2
    fileprivate let INTER_MARGIN: CGFloat = 9
    
    var totalLabel: UILabel?
    var customTextLabel: UILabel?
}

extension PXSummaryCompactComponentView {
    
    func buildView(amountAttributeText: NSAttributedString, bottomCustomTitle: NSAttributedString?, textColor: UIColor, backgroundColor: UIColor) -> CGFloat {
        
        self.backgroundColor = backgroundColor
        
        let (tLabel, cLabel) = buildLabels(amountText: amountAttributeText, customText: bottomCustomTitle, in: self, textColor: textColor)
        
        totalLabel = tLabel
        customTextLabel = cLabel
        
        var height: CGFloat = tLabel.requiredAttributedHeight() + INTER_MARGIN + TOP_BOTTOM_MARGIN
        if let optionalLabelHeight = cLabel?.requiredAttributedHeight() {
            height = height + optionalLabelHeight
        }
        
        return height
    }
    
    fileprivate func buildLabels(amountText: NSAttributedString?, customText: NSAttributedString?, in superView: UIView, textColor: UIColor) -> (UILabel, UILabel?) {
        
        let PERCENT_SCREEN_WIDTH: CGFloat = 95
        let amountLabel = UILabel()
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.textAlignment = .center
        amountLabel.numberOfLines = 1
        amountLabel.attributedText = amountText
        amountLabel.textColor = textColor
        superView.addSubview(amountLabel)
        
        PXLayout.pinTop(view: amountLabel, to: superView, withMargin: PXLayout.L_MARGIN).isActive = true
        PXLayout.centerHorizontally(view: amountLabel).isActive = true
        PXLayout.matchWidth(ofView: amountLabel).isActive = true
        
        if customText != nil {
            
            let customTitleLabel = UILabel()
            customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            customTitleLabel.textAlignment = .center
            customTitleLabel.numberOfLines = 2
            customTitleLabel.attributedText = customText
            customTitleLabel.textColor = textColor
            superView.addSubview(customTitleLabel)
            
            PXLayout.centerHorizontally(view: customTitleLabel).isActive = true
            PXLayout.matchWidth(ofView: customTitleLabel, toView: superView, withPercentage: PERCENT_SCREEN_WIDTH).isActive = true
            PXLayout.put(view: customTitleLabel, onBottomOf: amountLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
            
            return (amountLabel, customTitleLabel)
            
        } else {
            return (amountLabel, nil)
        }
    }
}
