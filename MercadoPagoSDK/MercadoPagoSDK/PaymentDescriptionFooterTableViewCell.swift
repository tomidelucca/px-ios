//
//  PaymentDescriptionFooterTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PaymentDescriptionFooterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paymentTotalDescription: MPLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setAmount(amount : Double, additionalText : String = ""){
        let fontAttrs : [String : AnyObject] = [NSFontAttributeName: UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 16)!]
        let total = NSMutableAttributedString(string: "Total a pagar ", attributes: fontAttrs)
        //TODO : obtener de servicio
        let attributedAmount = Utils.getAttributedAmount(String(amount), thousandSeparator: ",", decimalSeparator: ".", currencySymbol: "$", color : UIColor().UIColorFromRGB(0x666666), fontSize: 16, baselineOffset : 4)
        total.appendAttributedString(attributedAmount)
        self.paymentTotalDescription.attributedText = total
    }
    
}
