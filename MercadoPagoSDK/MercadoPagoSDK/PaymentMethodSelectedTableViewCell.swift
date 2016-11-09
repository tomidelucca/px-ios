//
//  PaymentMethodSelectedTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PaymentMethodSelectedTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentMethodIcon: UIImageView!
    
    @IBOutlet weak var paymentDescription: MPLabel!
    
    @IBOutlet weak var paymentMethodDescription: MPLabel!
    
    @IBOutlet weak var selectOtherPaymentMethodButton: MPButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderColor = UIColor.grayTableSeparator().cgColor
        self.contentView.layer.borderWidth = 1.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillCell(_ paymentMethod : PaymentMethod, amount : Double, installments : String? = "1", installmentAmount :Double? = 0, lastFourDigits : String? = "") {
        
        let currency = MercadoPagoContext.getCurrency()
        if paymentMethod.isCard() {
            self.paymentMethodIcon.image = MercadoPago.getImage("iconCard")
            self.paymentDescription.attributedText = Utils.getTransactionInstallmentsDescription(installments!, installmentAmount: installmentAmount!, additionalString: NSAttributedString(string : ""), color: UIColor.black, fontSize : 24)
            let paymentMethodDescription = NSMutableAttributedString(string: paymentMethod.name.localized)
            paymentMethodDescription.append(NSAttributedString(string : " terminada en " + lastFourDigits!))
            self.paymentMethodDescription.attributedText = paymentMethodDescription
        } else {
            self.paymentMethodIcon.image = MercadoPago.getImage("iconCash")
            let attributedAmount = Utils.getAttributedAmount(amount, thousandSeparator: currency.thousandsSeparator, decimalSeparator: currency.decimalSeparator, currencySymbol: currency.symbol, color : UIColor.black)
            let paymentOffDescription = NSMutableAttributedString(string: "Pagarás ".localized)
            paymentOffDescription.append(attributedAmount)
            paymentOffDescription.append(NSAttributedString(string : "con " + paymentMethod.name))
            self.paymentDescription.attributedText = paymentOffDescription
            
            self.paymentMethodDescription.text = ""
        }
        
        
    }
    
}
