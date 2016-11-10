//
//  PreferenceDescriptionCellTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 4/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class PurchaseDetailTableViewCell: UITableViewCell {

    static let ROW_HEIGHT = CGFloat(60)
    
    @IBOutlet weak var purchaseDetailTitle: MPLabel!
    
    @IBOutlet weak var purchaseDetailAmount: MPLabel!
    
    @IBOutlet weak var noRateLabel: MPLabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func fillCell(_ title : String, amount : Double, currency : Currency, payerCost : PayerCost? = nil){
        
        //Deafult values for cells
        self.purchaseDetailTitle.attributedText = NSAttributedString(string: title)
        self.noRateLabel.attributedText = NSAttributedString(string : "")
        var separatorLineHeight = CGFloat(54)
        
        if payerCost != nil {
            let purchaseAmount = getInstallmentsAmount(payerCost: payerCost!)
            self.purchaseDetailAmount.attributedText = purchaseAmount
            if !payerCost!.hasInstallmentsRate() {
                self.noRateLabel.attributedText = NSAttributedString(string : "Sin interés".localized)
                separatorLineHeight += 23
            }
        } else {
            self.purchaseDetailAmount.attributedText = Utils.getAttributedAmount(amount, thousandSeparator: currency.thousandsSeparator, decimalSeparator: currency.decimalSeparator, currencySymbol: currency.symbol, color : UIColor.grayDark(), fontSize : 18, baselineOffset : 5)
        }
        let separatorLine = ViewUtils.getTableCellSeparatorLineView(21, y: separatorLineHeight, width: self.frame.width - 42, height: 1)
        self.addSubview(separatorLine)
    }
    
    public static func getCellHeight(payerCost : PayerCost? = nil) -> CGFloat {
        if payerCost != nil && !payerCost!.hasInstallmentsRate() {
            return ROW_HEIGHT + 23
        }
        return ROW_HEIGHT
    }
    
    private func getInstallmentsAmount(payerCost : PayerCost) -> NSAttributedString {
//        let mpLightGrayColor = UIColor.grayLight()
//        let totalAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 24) ?? UIFont.systemFont(ofSize: 23),NSForegroundColorAttributeName:mpLightGrayColor]
//        let noRateAttributes = [NSForegroundColorAttributeName : UIColor(red: 67, green: 176,blue: 0), NSFontAttributeName : UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 13) ?? UIFont.systemFont(ofSize: 13)]
//        
//        let additionalText = NSMutableAttributedString(string : "")
//        if payerCost.installmentRate > 0 && payerCost.installments > 1 {
//            let totalAmountStr = NSMutableAttributedString(string:" ( ", attributes: totalAttributes)
//            let currency = MercadoPagoContext.getCurrency()
//            let totalAmount = Utils.getAttributedAmount(payerCost.totalAmount, thousandSeparator: String(currency.thousandsSeparator), decimalSeparator: String(currency.decimalSeparator), currencySymbol: String(currency.symbol), color:mpLightGrayColor)
//            totalAmountStr.append(totalAmount)
//            totalAmountStr.append(NSMutableAttributedString(string:" ) ", attributes: totalAttributes))
//            additionalText.append(totalAmountStr)
//        } else {
//            if payerCost.installments > 1 {
//                additionalText.append(NSAttributedString(string: " Sin interés".localized, attributes: noRateAttributes))
//            }
//        }
        
        return Utils.getTransactionInstallmentsDescription(payerCost.installments.description, installmentAmount: payerCost.installmentAmount, color: UIColor.grayBaseText(), fontSize : 24, baselineOffset : 8)

    }
    
}
