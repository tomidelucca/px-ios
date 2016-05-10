//
//  AuthorizePaymentBodyTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class AuthorizePaymentBodyTableViewCell: UITableViewCell {

    static let ROW_HEIGHT = CGFloat(216)
    override func awakeFromNib() {
        super.awakeFromNib()
        ViewUtils.drawBottomLine(155, width: self.bounds.width, inView: self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
