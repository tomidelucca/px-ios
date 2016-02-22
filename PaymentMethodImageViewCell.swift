//
//  PaymentMethodImageViewCellTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PaymentMethodImageViewCell: UITableViewCell {

    @IBOutlet weak var paymentMethodImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
