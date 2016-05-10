//
//  ExitButtonTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 10/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class ExitButtonTableViewCell: UITableViewCell {

    static let ROW_HEIGHT = CGFloat(60)
    
    @IBOutlet weak var exitButton: MPButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
