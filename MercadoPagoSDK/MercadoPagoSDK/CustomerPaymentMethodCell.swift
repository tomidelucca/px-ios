//
//  CustomerPaymentMethodCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/8/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class CustomerPaymentMethodCell: UITableViewCell {

    static let ROW_HEIGHT = CGFloat(52)
    
    @IBOutlet weak var paymentIcon: UIImageView!
    @IBOutlet weak var paymentMethodTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(ViewUtils.getTableCellSeparatorLineView(0, y: 0, width: self.frame.width, height: 1))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillRowWithCustomerPayment(customerPaymentMethod : CustomerPaymentMethod){
        self.paymentIcon.image = MercadoPago.getImage(customerPaymentMethod._id)
        self.paymentMethodTitle.text = customerPaymentMethod._description
    }

}
