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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillRowWithPaymentMethod(_ paymentMethod : PaymentMethod, lastFourDigits : String) {
       
    }
    
}
