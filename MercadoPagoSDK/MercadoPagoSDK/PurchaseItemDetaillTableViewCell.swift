//
//  PurchaseDetailImageTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 11/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PurchaseItemDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTitle: MPLabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(item : Item){
        //OJO
        //self.itemImage.image = item.pictureUrl
        self.itemTitle.text = item.title
    }
    
}
