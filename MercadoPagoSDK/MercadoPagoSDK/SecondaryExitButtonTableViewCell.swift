//
//  SecondaryExitButtonTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/21/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class SecondaryExitButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button.layer.cornerRadius = 3
        //self.button.addTarget(self, action: #selector(invokeCallback), for: .touchUpInside)
        self.button.setTitle("Pagar con otro medio".localized, for: .normal)
        self.button.titleLabel?.font = Utils.getFont(size: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
