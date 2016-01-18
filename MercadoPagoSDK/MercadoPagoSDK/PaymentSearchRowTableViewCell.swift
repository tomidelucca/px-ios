//
//  PaymentSearchRowTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PaymentSearchRowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paymentIcon: UIImageView!
    @IBOutlet weak var paymentTitle: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func fillRowWithPayment(paymentSearchItem : PaymentMethodSearchItem){
        self.paymentTitle.text = paymentSearchItem.description
        self.paymentIcon.image = MercadoPago.getImage("oxxo")//MercadoPago.getImage(paymentSearchItem.iconName)
        
    }
}
