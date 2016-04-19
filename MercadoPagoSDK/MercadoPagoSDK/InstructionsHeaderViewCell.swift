//
//  CongratsHeaderViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionsHeaderViewCell: UITableViewCell {


    @IBOutlet weak var headerTitle: MPLabel!
    @IBOutlet weak var instructionsHeaderIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tintedImage = instructionsHeaderIcon.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.instructionsHeaderIcon.image = tintedImage
        self.instructionsHeaderIcon.tintColor = UIColor().UIColorFromRGB(0xEFC701)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillCell(title : String, amount : Double) -> UITableViewCell {
        //TODO : servicio!
        let amountStr = Utils.getAmountFormatted(String(amount), thousandSeparator: ",", decimalSeparator: ".")
         let centsStr = Utils.getCentsFormatted(String(amount), decimalSeparator: ".")
        let amountRange = title.rangeOfString("$ " + amountStr + "." + centsStr)
        
        if amountRange != nil {
            let attributedTitle = NSMutableAttributedString(string: title.substringToIndex((amountRange?.startIndex)!))
            let attributedAmount = Utils.getAttributedAmount(amountStr, thousandSeparator: ",", decimalSeparator: ".", currencySymbol: "$", color: UIColor().UIColorFromRGB(0x666666))
            attributedTitle.appendAttributedString(attributedAmount)
            let endingTitle = NSAttributedString(string: title.substringFromIndex((amountRange?.endIndex)!))
            attributedTitle.appendAttributedString(endingTitle)
            self.headerTitle.attributedText = attributedTitle
            self.headerTitle.addCharactersSpacing(-0.4)
        } else {
            self.headerTitle.text = title
        }
        
        
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowColor = UIColor(red: 153, green: 153, blue: 153).CGColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.6
        return self
    }
    
}
