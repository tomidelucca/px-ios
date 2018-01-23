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
    static let TITLE_FONT_SIZE: CGFloat = 16.0
    static let CENTS_FONT_SIZE: CGFloat = 12.0

    let margin: CGFloat = 5.0
    var topMargin: CGFloat!
    var amount: Double!

    init(frame: CGRect, amount: Double, addBorder: Bool = true, topMargin: CGFloat = 20.0) {
        super.init(frame: frame)
        self.amount = amount
        self.topMargin = topMargin
        loadTotalView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadTotalView() {
        let stringAmount = titleForInstructions(amount: 1309.99)
        let props = PXTotalRowProps(totalAmount: stringAmount)
        let component = PXTotalRowComponent(props: props)
        let totalView = component.render()
        self.addSubview(totalView)
        PXLayout.matchHeight(ofView: totalView).isActive = true
        PXLayout.matchWidth(ofView: totalView).isActive = true
        PXLayout.centerVertically(view: totalView).isActive = true
        PXLayout.centerHorizontally(view: totalView).isActive = true
    }
    
    func titleForInstructions(amount: Double) -> NSMutableAttributedString {
        let currency = MercadoPagoContext.getCurrency()
        let currencySymbol = currency.getCurrencySymbolOrDefault()
        let thousandSeparator = currency.getThousandsSeparatorOrDefault()
        let decimalSeparator = currency.getDecimalSeparatorOrDefault()
        
        let attributedTitle = NSMutableAttributedString(string: "Total: ".localized, attributes: [NSFontAttributeName: Utils.getFont(size: TotalAmountCell.TITLE_FONT_SIZE)])
        let attributedAmount = Utils.getAttributedAmount(amount, thousandSeparator: thousandSeparator, decimalSeparator: decimalSeparator, currencySymbol: currencySymbol, color: UIColor.px_white(), fontSize:TotalAmountCell.TITLE_FONT_SIZE, centsFontSize:TotalAmountCell.CENTS_FONT_SIZE, smallSymbol: false)
        attributedTitle.append(attributedAmount)
        return attributedTitle
    }

}
