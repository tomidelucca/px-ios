//
//  PreferenceDescriptionCellTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 4/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class PurchaseDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var purchaseDetailTitle: MPLabel!
    
    @IBOutlet weak var purchaseDetailAmount: MPLabel!
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func fillRow(_ title : String, amount : Double, currency : Currency){
        
        self.purchaseDetailTitle.attributedText = NSAttributedString(string: title)
    
    //    self.purchaseDetailAmount.attributedText = Utils.getAttributedAmount(amount, thousandSeparator: currency.thousandsSeparator, decimalSeparator: currency.decimalSeparator, currencySymbol: currency.symbol)

//        self.fillRowWithSettings(preference.getAmount(), purchaseTitle: preference.getTitle(), pictureUrl: preference.getPictureUrl(), currency : currency!)
//        if (preference.choImage != nil){
//             ViewUtils.addScaledImage(preference.choImage!, inView: self.shoppingCartIconContainer)
//        }
    }
    
//    internal func fillRowWithSettings(_ amount : Double, purchaseTitle: String? = "", pictureUrl : String? = "", currency : Currency){
//        self.preferenceAmount.attributedText = Utils.getAttributedAmount(amount, thousandSeparator: String(currency.getThousandsSeparatorOrDefault()), decimalSeparator: String(currency.getDecimalSeparatorOrDefault()), currencySymbol: String(currency.getCurrencySymbolOrDefault()))
//        self.preferenceDescription.text = purchaseTitle
//        
//      
//        
//        if  !String.isNullOrEmpty(pictureUrl) {
//            if self.shoppingCartIconContainer.subviews.count == 0 {
//                self.shoppingCartIcon.removeFromSuperview()
//                ViewUtils.loadImageFromUrl(pictureUrl!, inView: self.shoppingCartIconContainer)
//            }
//        }
//    
//         self.preferenceAmount.textColor = UIColor.systemFontColor()
//        self.preferenceDescription.textColor = UIColor.systemFontColor()
//    }
    
  
    
}
