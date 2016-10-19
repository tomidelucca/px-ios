//
//  CardTypeTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/18/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class CardTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var cardTypeLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setText(text: String){
        cardTypeLable.text = text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
