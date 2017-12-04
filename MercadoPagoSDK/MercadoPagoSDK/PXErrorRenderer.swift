//
//  PXErrorRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/4/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXErrorRenderer: NSObject {

    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let LABEL_FONT_SIZE: CGFloat = 22.0
    
    func render(component: PXErrorComponent) -> PXErrorView {
        let errorBodyView = PXErrorView()
        errorBodyView.backgroundColor = .yellow
        errorBodyView.translatesAutoresizingMaskIntoConstraints = false
        
        errorBodyView.titleLabel = buildLabel(with: component.getTitle(), in: errorBodyView)
        errorBodyView.addSubview(errorBodyView.titleLabel!)
        
        errorBodyView.descriptionLabel = buildLabel(with: component.getDescription(), in: errorBodyView)
        errorBodyView.addSubview(errorBodyView.descriptionLabel!)
        
        if component.hasActionForCallForAuth() {
            errorBodyView.actionLabel = buildLabel(with: component.getActionText(), in: errorBodyView)
            errorBodyView.addSubview(errorBodyView.actionLabel!)
            
            errorBodyView.secondaryTitleLabel = buildLabel(with: component.getSecondaryTitleForCallForAuth(), in: errorBodyView)
            errorBodyView.addSubview(errorBodyView.secondaryTitleLabel!)
            
            errorBodyView.middleDivider = buildBottomDivider(in: errorBodyView, onBottomOf: errorBodyView.secondaryTitleLabel)
        }
        
        
        PXLayout.setHeight(owner: errorBodyView, height: 100).isActive = true
        return errorBodyView
    }
    
    func buildLabel(with text: NSAttributedString, in superView: UIView) -> UILabel {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .pxBrownishGray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.attributedText = text
        subtitleLabel.lineBreakMode = .byWordWrapping
        superView.addSubview(subtitleLabel)
        
        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)
        
        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: LABEL_FONT_SIZE), inWidth: screenWidth)
        PXLayout.setHeight(owner: subtitleLabel, height: height).isActive = true
        PXLayout.setWidth(ofView: subtitleLabel, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        PXLayout.centerHorizontally(view: subtitleLabel, to: superView).isActive = true
        PXLayout.pinBottom(view: subtitleLabel, to: superView, withMargin: PXLayout.L_MARGIN).isActive = true
        PXLayout.pinTop(view: subtitleLabel, to: superView, withMargin: PXLayout.L_MARGIN).isActive = true
        return subtitleLabel
    }
    
    func buildBottomDivider(in superView: UIView, onBottomOf upperView: UIView?) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let view = UIView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .pxMediumLightGray
        superView.addSubview(view)
        PXLayout.setHeight(owner: view, height: 1).isActive = true
        PXLayout.setWidth(ofView: view, asWidthOfView: superView).isActive = true
        PXLayout.centerHorizontally(view: view, to: superView).isActive = true
        
        if let upperView = upperView {
            PXLayout.put(view: view, onBottomOf:upperView, withMargin: PXLayout.L_MARGIN).isActive = true
        }
        
        return view
    }
}

class PXErrorView: PXBodyView {
    var titleLabel: UILabel?
    var descriptionLabel: UILabel?
    var actionLabel: UILabel?
    var middleDivider: UIView?
    var secondaryTitleLabel: UILabel?
    var bottomDivider: UIView?
}
