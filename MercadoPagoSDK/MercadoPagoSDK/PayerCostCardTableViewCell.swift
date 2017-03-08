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
    var cellView: UIView!
    var cardFront : CardFrontView!
    
    func loadCellView(View: UIView?){
        
        if var cardView = View{
            self.cellView = UIView()
            
            let cellViewHeight = getCardHeight()
            let cellViewWidht = getCardWidth()
            let xMargin = (UIScreen.main.bounds.size.width  - cellViewWidht) / 2
            let yMargin = (UIScreen.main.bounds.size.width*0.5 - cellViewHeight ) / 2
            
            let rectBackground = CGRect(x: xMargin, y: yMargin, width: cellViewWidht, height: cellViewHeight)
            let rect = CGRect(x: 0, y: 0, width: cellViewWidht, height: cellViewHeight)
            self.cellView.frame = rectBackground
            
            self.cellView.layer.cornerRadius = 8
            self.cellView.layer.masksToBounds = true
            self.addSubview(self.cellView)
            
            cardView = UIView(frame: rect)
            cardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            cellView.addSubview(cardView)
            self.cell.backgroundColor = UIColor.primaryColor()
        }
        
    }
    func updateCardSkin(token: CardInformationForm?, paymentMethod: PaymentMethod?) {
        
        if let paymentMethod = paymentMethod{
            
            self.cardFront?.cardLogo.image =  MercadoPago.getImageFor(paymentMethod)
            self.cellView.backgroundColor = MercadoPago.getColorFor(paymentMethod)
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
            self.cellView?.alpha = 0
        }
        
    }
    func showCard(){
        UIView.animate(withDuration: 1.50) {
            self.cellView?.alpha = 1
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
