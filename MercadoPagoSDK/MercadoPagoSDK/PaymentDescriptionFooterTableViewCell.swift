//
//  PaymentDescriptionFooterTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PaymentDescriptionFooterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paymentTotalDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setAmount(amount : Double){
        self.paymentTotalDescription.text = "Total a pagar $" + String(amount)
    }
    
}
