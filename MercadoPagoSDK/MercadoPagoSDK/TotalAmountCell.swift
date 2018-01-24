//
//  TotalAmountCell.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 1/23/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

class TotalAmountCell: UIView {
    static let HEIGHT: CGFloat = 42.0
    
    let TITLE_FONT_SIZE: CGFloat = 16.0
    let CENTS_FONT_SIZE: CGFloat = 12.0
    
    var amount: Double!
    var addBottomLine: Bool!

    init(frame: CGRect, amount: Double, addBottomLine: Bool = true) {
        super.init(frame: frame)
        self.amount = amount
        self.addBottomLine = addBottomLine
        loadTotalView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadTotalView() {
        PXLayout.setHeight(owner: self, height: TotalAmountCell.HEIGHT).isActive = true
        let textAmount = titleForRow(amount: self.amount)
        let props = PXTotalRowProps(totalAmount: textAmount)
        let component = PXTotalRowComponent(props: props)
        let totalView = component.render()
        self.addSubview(totalView)
        PXLayout.matchHeight(ofView: totalView).isActive = true
        PXLayout.matchWidth(ofView: totalView).isActive = true
        PXLayout.centerVertically(view: totalView).isActive = true
        PXLayout.centerHorizontally(view: totalView).isActive = true
        if addBottomLine {
            totalView.addSeparatorLineToBottom(height: 1, horizontalMarginPercentage: 100)
        }
    }
    
    func titleForRow(amount: Double) -> NSMutableAttributedString {
        let currency = MercadoPagoContext.getCurrency()
        let currencySymbol = currency.getCurrencySymbolOrDefault()
        let thousandSeparator = currency.getThousandsSeparatorOrDefault()
        let decimalSeparator = currency.getDecimalSeparatorOrDefault()
        let decimalPlaces = currency.getDecimalPlacesOrDefault()
        
        let cents = Utils.getCentsFormatted(amount.stringValue, decimalSeparator: decimalSeparator, decimalPlaces: decimalPlaces)
        let mustShowCents = cents != "00"
        
        let attributedTitle = NSMutableAttributedString(string: "Total: ".localized, attributes: [NSFontAttributeName: Utils.getFont(size: self.TITLE_FONT_SIZE)])
        let attributedAmount = Utils.getAttributedAmount(amount, thousandSeparator: thousandSeparator, decimalSeparator: decimalSeparator, currencySymbol: currencySymbol, color: UIColor.px_white(), fontSize:self.TITLE_FONT_SIZE, centsFontSize:self.CENTS_FONT_SIZE, baselineOffset: 3, smallSymbol: false, showCents: mustShowCents)
        attributedTitle.append(attributedAmount)
        return attributedTitle
    }

}
