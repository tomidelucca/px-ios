//
//  PreferenceDescriptionCellTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 4/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PreferenceDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var preferenceDescription: UILabel!
    
    @IBOutlet weak var shoppingCartIcon: UIImageView!
    @IBOutlet weak var preferenceAmount: UILabel!

    @IBOutlet weak var shoppingCartIconContainer: UIView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tintedImage = self.shoppingCartIcon.image!.imageWithRenderingMode(.AlwaysTemplate)
        self.shoppingCartIcon.image = tintedImage
        self.shoppingCartIcon.tintColor = UIColor().white()
        
        self.shoppingCartIconContainer.layer.borderWidth = 1.0
        self.shoppingCartIconContainer.layer.borderColor = UIColor.whiteColor().CGColor
        
    
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func fillRowWithPreference(preference : CheckoutPreference){
        self.fillRowWithSettings(preference.getAmount(), purchaseTitle: preference.items![0].title, pictureUrl: preference.items![0].pictureUrl)
    }
    
    internal func fillRowWithSettings(amount : Double, purchaseTitle: String, pictureUrl : String?){
        //TODO : deberia venir de servicio
        self.preferenceAmount.attributedText = Utils.getAttributedAmount(String(amount), thousandSeparator: ",", decimalSeparator: ".", currencySymbol: "$")
        self.preferenceDescription.text = purchaseTitle
        if pictureUrl != nil {
            self.shoppingCartIcon.image = MercadoPago.getImage(pictureUrl!)
        }
    }
    
}
