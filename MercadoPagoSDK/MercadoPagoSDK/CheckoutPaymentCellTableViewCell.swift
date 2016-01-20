//
//  CheckoutPaymentCellTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 19/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class CheckoutPaymentCellTableViewCell: UITableViewCell {


    @IBOutlet weak var paymentIcon: UIImageView!
    
    @IBOutlet weak var paymentDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
