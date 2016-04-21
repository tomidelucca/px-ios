//
//  PaymentMethodCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 29/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class OfflinePaymentMethodCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var comment: MPLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(ViewUtils.getTableCellSeparatorLineView(self.iconImage.frame.minX, y: 0, width: self.frame.width, height: 1))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func fillRowWithPaymentMethod(paymentMethod : PaymentMethodSearchItem, image : UIImage){
        self.iconImage.image = image
        self.comment.text = (paymentMethod.comment!)
    }
    
    internal func fillRowWithPaymentMethod(paymentMethod : PaymentMethod){
        self.iconImage.image = MercadoPago.getImageFor(paymentMethod)
        self.comment.text = (paymentMethod.comment!)
    }
}
