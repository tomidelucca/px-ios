//
//  PXTermsAndConditionView.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 5/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXTermsAndConditionView: PXComponentView {
    
    static let SCREEN_NAME = "TERMS_AND_CONDITIONS"
    static let SCREEN_TITLE = "Términos y Condiciones"
    
    fileprivate let termsAndConditionsText: MPTextView = MPTextView()
    
    override init() {
        
        super.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        termsAndConditionsText.translatesAutoresizingMaskIntoConstraints = false

        termsAndConditionsText.attributedText = getTyCText()
        
        addSubview(termsAndConditionsText)
        
        let URLAttribute = [NSFontAttributeName: UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 12) ?? UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: ThemeManager.shared.getTheme().secondaryButton().tintColor] as [String: Any]
        
        termsAndConditionsText.linkTextAttributes = URLAttribute
        
        let PERCENT_WIDTH: CGFloat = 90.0
        PXLayout.matchWidth(ofView: termsAndConditionsText, toView: self, withPercentage: PERCENT_WIDTH).isActive = true
        
        PXLayout.centerHorizontally(view: termsAndConditionsText).isActive = true
        
        let dynamicHeight: CGFloat = termsAndConditionsText.contentSize.height + PXLayout.S_MARGIN
        
        PXLayout.setHeight(owner: termsAndConditionsText, height: dynamicHeight).isActive = true
        
        PXLayout.pinTop(view: termsAndConditionsText, withMargin: PXLayout.S_MARGIN).isActive = true
        
        PXLayout.pinBottom(view: termsAndConditionsText, withMargin: PXLayout.S_MARGIN).isActive = true

        addSeparatorLineToBottom(height: 1.0, horizontalMarginPercentage: 100.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PXTermsAndConditionView {
    
    fileprivate func getTyCText() -> NSMutableAttributedString {
        
        let termsAndConditionsText = "Al pagar, afirmo que soy mayor de edad y acepto los Términos y Condiciones de Mercado Pago".localized
        let normalAttributes: [String: AnyObject] = [NSFontAttributeName: Utils.getFont(size: 12), NSForegroundColorAttributeName: ThemeManager.shared.getTheme().labelTintColor()]
        
        let mutableAttributedString = NSMutableAttributedString(string: termsAndConditionsText, attributes: normalAttributes)
        let tycLinkRange = (termsAndConditionsText as NSString).range(of: PXTermsAndConditionView.SCREEN_TITLE.localized)
        
        mutableAttributedString.addAttribute(NSLinkAttributeName, value: MercadoPagoContext.getTermsAndConditionsSite(), range: tycLinkRange)
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineSpacing = CGFloat(6)
        
        mutableAttributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, mutableAttributedString.length))
        
        return mutableAttributedString
    }
}
