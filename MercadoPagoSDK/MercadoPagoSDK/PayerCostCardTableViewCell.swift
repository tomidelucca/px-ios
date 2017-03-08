//
//  PayerCostCardTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/13/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PayerCostCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cell: UIView!
    var containerView: UIView!
    var cardFront : CardFrontView!
    
    func loadCellView(View: UIView?){
        
        if var content = View{
            self.containerView = UIView()
            
            let containerHeight = getCardHeight()
            let containerWidht = getCardWidth()
            let xMargin = (UIScreen.main.bounds.size.width  - containerWidht) / 2
            let yMargin = (UIScreen.main.bounds.size.width*0.5 - containerHeight ) / 2
            
            let rectBackground = CGRect(x: xMargin, y: yMargin, width: containerWidht, height: containerHeight)
            let rect = CGRect(x: 0, y: 0, width: containerWidht, height: containerHeight)
            
            self.containerView.frame = rectBackground
            self.containerView.layer.cornerRadius = 8
            self.containerView.layer.masksToBounds = true
            self.addSubview(self.containerView)
            
            content = UIView(frame: rect)
            content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            containerView.addSubview(content)
            self.cell.backgroundColor = UIColor.primaryColor()
        }
        
    }
    func updateCardSkin(token: CardInformationForm?, paymentMethod: PaymentMethod?) {
        
        if let paymentMethod = paymentMethod{
            
            self.cardFront?.cardLogo.image =  MercadoPago.getImageFor(paymentMethod)
            self.containerView.backgroundColor = MercadoPago.getColorFor(paymentMethod)
            self.cardFront?.cardLogo.alpha = 1
            let fontColor = MercadoPago.getFontColorFor(paymentMethod)!
            if let token = token{
          //  cardFront?.cardNumber.text =  "•••• •••• •••• " + (token.getCardLastForDigits())!
                let mask = TextMaskFormater(mask: paymentMethod.getLabelMask(), completeEmptySpaces: true, leftToRight: false)
                cardFront?.cardNumber.text = mask.textMasked(token.getCardLastForDigits())
            }
            
            cardFront?.cardName.text = ""
            cardFront?.cardExpirationDate.text = ""
            cardFront?.cardNumber.alpha = 0.8
            cardFront?.cardNumber.textColor =  fontColor
        }
    }
    func fadeCard(){
        UIView.animate(withDuration: 0.80) {
            self.containerView?.alpha = 0
        }
        
    }
    func showCard(){
        UIView.animate(withDuration: 1.50) {
            self.containerView?.alpha = 1
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
    func getCardWidth() -> CGFloat {
        let widthTotal = UIScreen.main.bounds.size.width * 0.70
        if widthTotal < 512 {
            if ((0.63 * widthTotal) < (UIScreen.main.bounds.size.width*0.50 - 10)){
                return widthTotal * 0.8
            }else{
                return (UIScreen.main.bounds.size.width*0.50 - 10) / 0.63 * 0.8
            }
            
        }else{
            return 512 * 0.8
        }
        
    }
    
    func getCardHeight() -> CGFloat {
        return ( getCardWidth() * 0.63 )
    }
}
