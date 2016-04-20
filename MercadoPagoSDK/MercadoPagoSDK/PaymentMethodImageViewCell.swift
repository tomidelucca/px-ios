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
        self.addSubview(ViewUtils.getTableCellSeparatorLineView(paymentMethodImage.frame.minX, y: 0, width: self.frame.width, height: 1))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
