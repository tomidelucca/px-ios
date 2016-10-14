//
//  PayerCostRowTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/13/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PayerCostRowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var interestDescription: UILabel!
    @IBOutlet weak var installmentDescription: UILabel!
    
    func fillCell(payerCost : PayerCost) {
        let currency = MercadoPagoContext.getCurrency()
        if (payerCost.installmentRate != 0){
            let attributedTotal = NSMutableAttributedString(attributedString: NSAttributedString(string: "( ", attributes: [NSForegroundColorAttributeName : UIColor(red: 153, green: 153, blue: 153)]))
            attributedTotal.append(Utils.getAttributedAmount(payerCost.totalAmount, thousandSeparator: String(currency.thousandsSeparator), decimalSeparator: String(currency.decimalSeparator), currencySymbol: String(currency.symbol), color:UIColor(red: 153, green: 153, blue: 153), fontSize:15))
            attributedTotal.append(NSAttributedString(string: " )", attributes: [NSForegroundColorAttributeName : UIColor(red: 153, green: 153, blue: 153)]))
            
            interestDescription.attributedText = attributedTotal
            
        } else {
            interestDescription.text = "Sin interés"
        }
        var message:String = String(format:"%i", payerCost.installments)
        message = "\(message) x "
        let totalAmount = Utils.getAttributedAmount(payerCost.installmentAmount, thousandSeparator: String(currency.thousandsSeparator), decimalSeparator: String(currency.decimalSeparator), currencySymbol: String(currency.symbol), color:UIColor(red: 51, green: 51, blue: 51))
        
        let cuotas = NSMutableAttributedString(string: message)
        cuotas.append(totalAmount)
        installmentDescription.attributedText =  cuotas
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
