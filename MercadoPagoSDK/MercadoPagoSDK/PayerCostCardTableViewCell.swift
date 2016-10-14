//
//  PayerCostCardTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/13/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PayerCostCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    var cardFront : CardFrontView?
    
    func loadCard(){
        cardFront = CardFrontView(frame: self.cardView.bounds)
        cardFront?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardView.addSubview(cardFront!)
    }
    func updateCardSkin(token: Token!, paymentMethod: PaymentMethod?) {
        
        if let paymentMethod = paymentMethod{
            
            self.cardFront?.cardLogo.image =  MercadoPago.getImageFor(paymentMethod)
            self.cardView.backgroundColor = MercadoPago.getColorFor(paymentMethod)
            self.cardFront?.cardLogo.alpha = 1
            let fontColor = MercadoPago.getFontColorFor(paymentMethod)!
            
            cardFront?.cardNumber.text =  "XXXX XXXX XXXX " + (token.lastFourDigits as String)
            // TODO
            
            cardFront?.cardName.text = token.cardHolder!.name
            cardFront?.cardExpirationDate.text = token.getExpirationDateFormated() as String
            cardFront?.cardNumber.alpha = 0.7
            cardFront?.cardName.alpha = 0.7
            cardFront?.cardExpirationDate.alpha = 0.7
            cardFront?.cardNumber.textColor =  fontColor
            cardFront?.cardName.textColor =  fontColor
            cardFront?.cardExpirationDate.textColor =  fontColor
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
