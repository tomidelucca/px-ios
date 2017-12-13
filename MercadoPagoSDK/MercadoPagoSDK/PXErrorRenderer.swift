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
    let TITLE_FONT_SIZE: CGFloat = 24.0
    let DESCRIPTION_FONT_SIZE: CGFloat = 20.0
    let ACTION_FONT_SIZE: CGFloat = 18.0
    let ACTION_LABEL_FONT_COLOR: UIColor = .px_blueMercadoPago()
    
    func render(component: PXErrorComponent) -> PXErrorView {
        let errorBodyView = PXErrorView()
        errorBodyView.backgroundColor = .pxWhite
        errorBodyView.translatesAutoresizingMaskIntoConstraints = false
        
        //Content View
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        errorBodyView.addSubview(contentView)
        PXLayout.centerHorizontally(view: contentView, to: errorBodyView).isActive = true
        PXLayout.centerVertically(view: contentView, into: errorBodyView).isActive = true
        PXLayout.equalizeWidth(view: contentView, to: errorBodyView).isActive = true
        
        //Title Label
        errorBodyView.titleLabel = buildTitleLabel(with: component.getTitle(), in: contentView)
        contentView.addSubview(errorBodyView.titleLabel!)
        
        //Description Label
        errorBodyView.descriptionLabel = buildDescriptionLabel(with: component.getDescription(), in: contentView, onBottomOf: errorBodyView.titleLabel)
        contentView.addSubview(errorBodyView.descriptionLabel!)
        
        //Action Button
        if component.hasActionForCallForAuth() {
            errorBodyView.actionButton = buildActionButton(withTitle: component.getActionText(), in: contentView, onBottomOf: errorBodyView.descriptionLabel, component: component)
            contentView.addSubview(errorBodyView.actionButton!)
            
            errorBodyView.middleDivider = buildMiddleDivider(in: contentView, onBottomOf: errorBodyView.actionButton)
            contentView.addSubview(errorBodyView.middleDivider!)
            
            errorBodyView.secondaryTitleLabel = buildSecondaryTitleLabel(with: component.getSecondaryTitleForCallForAuth(), in: contentView, onBottomOf: errorBodyView.middleDivider)
            contentView.addSubview(errorBodyView.secondaryTitleLabel!)

            errorBodyView.bottomDivider = buildBottomDivider(in: contentView, onBottomOf: errorBodyView.secondaryTitleLabel)
            contentView.addSubview(errorBodyView.bottomDivider!)
            PXLayout.pinLastSubviewToBottom(view: contentView, withMargin: PXLayout.ZERO_MARGIN)?.isActive = true
        } else {
            PXLayout.pinLastSubviewToBottom(view: contentView, withMargin: PXLayout.L_MARGIN)?.isActive = true
        }
        
        contentView.layer.borderWidth = 1
        errorBodyView.layer.borderWidth = 3
        
//        PXLayout.pinTop(view: contentView, to: errorBodyView).isActive = true
//        PXLayout.pinBottom(view: contentView, to: errorBodyView).isActive = true

        return errorBodyView
    }
    
    func buildTitleLabel(with text: String, in superView: UIView) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .pxBlack
        label.numberOfLines = 0
        
        let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_FONT_SIZE) ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
        label.lineBreakMode = .byWordWrapping
        superView.addSubview(label)

        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)

        let height = UILabel.requiredHeight(forAttributedText: attributedString, withFont: Utils.getFont(size: TITLE_FONT_SIZE), inWidth: screenWidth)
        PXLayout.setHeight(owner: label, height: height).isActive = true
        PXLayout.setWidth(ofView: label, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        PXLayout.centerHorizontally(view: label, to: superView).isActive = true
        PXLayout.pinTop(view: label, to: superView, withMargin: PXLayout.L_MARGIN).isActive = true
        return label
    }
    
    func buildDescriptionLabel(with text: String, in superView: UIView, onBottomOf upperView: UIView?) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .pxBrownishGray
        label.numberOfLines = 0
        
        let attributes = [ NSFontAttributeName: Utils.getFont(size: DESCRIPTION_FONT_SIZE) ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
        
        label.lineBreakMode = .byWordWrapping
        superView.addSubview(label)
        
        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)
        
        let height = UILabel.requiredHeight(forAttributedText: attributedString, withFont: Utils.getFont(size: DESCRIPTION_FONT_SIZE), inWidth: screenWidth)
        PXLayout.setHeight(owner: label, height: height).isActive = true
        PXLayout.setWidth(ofView: label, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        PXLayout.centerHorizontally(view: label, to: superView).isActive = true
        if let upperView = upperView {
            PXLayout.put(view: label, onBottomOf: upperView, withMargin: PXLayout.S_MARGIN).isActive = true
        }
        return label
    }
    
    func buildActionButton(withTitle text: String, in superView: UIView, onBottomOf upperView: UIView?, component: PXErrorComponent) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = Utils.getFont(size: ACTION_FONT_SIZE)
        button.setTitleColor(ACTION_LABEL_FONT_COLOR, for: .normal)
        button.add(for: .touchUpInside) {
            component.recoverPayment()
        }
        superView.addSubview(button)
        
        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)
        
        let height = UILabel.requiredHeight(forText: text, withFont: Utils.getFont(size: ACTION_FONT_SIZE), inNumberOfLines: 0, inWidth: screenWidth)
        PXLayout.setHeight(owner: button, height: height).isActive = true
        PXLayout.setWidth(ofView: button, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        PXLayout.centerHorizontally(view: button, to: superView).isActive = true
        
        if let upperView = upperView {
            PXLayout.put(view: button, onBottomOf: upperView, withMargin: PXLayout.M_MARGIN).isActive = true
        }
        return button
    }

    func buildSecondaryTitleLabel(with text: String, in superView: UIView, onBottomOf upperView: UIView?) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .pxBlack
        label.numberOfLines = 0

        let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_FONT_SIZE) ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString

        label.lineBreakMode = .byWordWrapping
        superView.addSubview(label)

        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)

        let height = UILabel.requiredHeight(forAttributedText: attributedString, withFont: Utils.getFont(size: TITLE_FONT_SIZE), inWidth: screenWidth)
        PXLayout.setHeight(owner: label, height: height).isActive = true
        PXLayout.setWidth(ofView: label, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        PXLayout.centerHorizontally(view: label, to: superView).isActive = true
        if let upperView = upperView {
            PXLayout.put(view: label, onBottomOf: upperView, withMargin: PXLayout.L_MARGIN).isActive = true
        }
        return label
    }

    func buildMiddleDivider(in superView: UIView, onBottomOf upperView: UIView?) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .pxMediumLightGray
        superView.addSubview(view)
        PXLayout.setHeight(owner: view, height: 1).isActive = true
        PXLayout.setWidth(ofView: view, asWidthOfView: superView).isActive = true
        PXLayout.centerHorizontally(view: view, to: superView).isActive = true

        if let upperView = upperView {
            PXLayout.put(view: view, onBottomOf:upperView, withMargin: PXLayout.XXL_MARGIN).isActive = true
        }
        return view
    }

    func buildBottomDivider(in superView: UIView, onBottomOf upperView: UIView?) -> UIView {
        let view = UIView()
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
    var actionButton: UIButton?
    var middleDivider: UIView?
    var secondaryTitleLabel: UILabel?
    var bottomDivider: UIView?
}
