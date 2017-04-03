//
//  BankInsterestTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 4/3/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class BankInsterestTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainLabel.text = "No incluye intereses bancarios".localized
        mainLabel.textAlignment = .center
        mainLabel.font.withSize(14)
        mainLabel.textColor = UIColor.systemFontColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
