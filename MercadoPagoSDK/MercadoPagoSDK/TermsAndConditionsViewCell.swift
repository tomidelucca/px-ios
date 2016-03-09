//
//  TermsAndConditionsViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class TermsAndConditionsViewCell: UITableViewCell {

    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.paymentButton.layer.cornerRadius = 4
        self.paymentButton.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
