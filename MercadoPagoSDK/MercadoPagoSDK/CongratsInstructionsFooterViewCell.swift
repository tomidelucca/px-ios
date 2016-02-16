//
//  CongratsInstructionsFooterViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class CongratsInstructionsFooterViewCell: UITableViewCell {

    @IBOutlet weak var clockIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tintedImage = self.clockIcon.image?.imageWithRenderingMode(.AlwaysTemplate)
        self.clockIcon.image = tintedImage
        self.clockIcon.tintColor = UIColor().UIColorFromRGB(0xB29054)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
