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
    
    internal func fillCell(_ title : String, amount : Double, currency : Currency){
        
       self.purchaseDetailTitle.attributedText = NSAttributedString(string: title)
    
        self.purchaseDetailAmount.attributedText = Utils.getAttributedAmount(amount, thousandSeparator: currency.thousandsSeparator, decimalSeparator: currency.decimalSeparator, currencySymbol: currency.symbol, color : UIColor.grayDark())

    }
  
    
}
