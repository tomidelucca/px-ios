//
//  ApprovedPaymentBodyTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class RejectedPaymentBodyTableViewCell: UITableViewCell {

    static let ROW_HEIGHT = CGFloat(196)
    
    @IBOutlet weak var cancelButton: MPButton!
    @IBOutlet weak var payAgainButton: MPButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.payAgainButton.layer.cornerRadius = 5
        self.payAgainButton.layer.borderWidth = 1
        self.payAgainButton.layer.borderColor = UIColor().blueMercadoPago().CGColor
        ViewUtils.drawBottomLine(122, width : self.bounds.width, inView: self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
