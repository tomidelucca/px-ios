//
//  PaymentMethodCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 29/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class OfflinePaymentMethodCell: UITableViewCell {

    static let ROW_HEIGHT = CGFloat(80)
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var comment: MPLabel!
    
    @IBOutlet weak var paymentItemDescription: MPLabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(ViewUtils.getTableCellSeparatorLineView(self.iconImage.frame.minX, y: 0, width: self.frame.width, height: 1))

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func fillRowWithPaymentMethod(paymentMethod : PaymentMethodSearchItem, image : UIImage, paymentItemDescription : String = "") {
        self.iconImage.image = image
        self.comment.text = (paymentMethod.comment!)
        self.paymentItemDescription.text = paymentItemDescription
    }
    
    internal func fillRowWithPaymentMethod(paymentMethod : PaymentMethod, paymentMethodSearchItemSelected : PaymentMethodSearchItem) {
        self.iconImage.image = MercadoPago.getImageFor(paymentMethod)
        if paymentMethodSearchItemSelected.comment?.characters.count > 0 {
            self.comment.text = paymentMethodSearchItemSelected.comment
        } else {
            self.comment.text = Utils.getAccreditationTitle(paymentMethod)
        }
        
        self.paymentItemDescription.text = paymentMethodSearchItemSelected.description
        
        let customAccesoryIndicator = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: 1, height: 1))
        let iconImage = MercadoPago.getImage("edit")!
        iconImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        customAccesoryIndicator.tintColor = UIColor().blueMercadoPago()
        let editImage = UIImageView(image: iconImage)
        
        editImage.tintColor = UIColor().blueMercadoPago()
        customAccesoryIndicator.addSubview(editImage)
        self.accessoryView = customAccesoryIndicator
    }
}
