//
//  PurchaseItemAmountTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 11/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PurchaseItemAmountTableViewCell: UITableViewCell {

    @IBOutlet weak var unitPrice: MPLabel!
    @IBOutlet weak var quantity: MPLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(_ item : Item){
        self.unitPrice.text = String(item.unitPrice)
        self.quantity.text = String(item.quantity)
    }
    
}
