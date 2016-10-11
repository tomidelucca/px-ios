//
//  AuthorizePaymentTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class AuthorizePaymentHeaderTableViewCell: UITableViewCell, CongratsFillmentDelegate {

    static let ROW_HEIGHT = CGFloat(240)
    
    @IBOutlet weak var title: MPLabel!
    
    
    @IBOutlet weak var subtitle: MPLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.addCharactersSpacing(-0.4)
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowColor = UIColor(red: 153, green: 153, blue: 153).CGColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.6

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillCell(payment: Payment, paymentMethod : PaymentMethod, callback : (Void -> Void)?) -> UITableViewCell {
        self.title.attributedText = self.getTitle(payment, paymentMethod: paymentMethod)
        self.title.addLineSpacing(4)
        self.subtitle.text = "El teléfono está al dorso de tu tarjeta".localized
        
        return self
    }
    
    func getCellHeight(payment : Payment, paymentMethod : PaymentMethod) -> CGFloat {
        
        var constraintSize = CGSize()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        constraintSize.width = screenSize.width - 46
        
        let attributesTitle = [NSFontAttributeName: UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 22) ?? UIFont.systemFontOfSize(22)]
        
        let title = String(getTitle(payment, paymentMethod: paymentMethod).mutableString)
        
        let frameTitle = (title as NSString).boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributesTitle, context: nil)
        
        let stringSizeTitle = frameTitle.size
        
        let attributesSubtitle = [NSFontAttributeName: UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 14) ?? UIFont.systemFontOfSize(14)]
        let subtitle = "El teléfono está al dorso de tu tarjeta".localized
        
        let frameSubtitle = (subtitle as NSString).boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributesSubtitle, context: nil)
        
        let stringSizeSubtitle = frameSubtitle.size
        return 150 + stringSizeTitle.height + stringSizeSubtitle.height
    }

    private func getTitle(payment : Payment, paymentMethod : PaymentMethod) -> NSMutableAttributedString {
        if paymentMethod._id == nil || paymentMethod._id == nil || paymentMethod.name == nil || paymentMethod.name.isEmpty {
            return NSMutableAttributedString(string: "Debes autorizar el pago ante tu tarjeta".localized)
        }
        
        let currency = MercadoPagoContext.getCurrency()

        let title = NSMutableAttributedString(string: ("Debes autorizar ante %1$s el pago de ".localized as NSString).stringByReplacingOccurrencesOfString("%1$s", withString: paymentMethod.name))
        let attributedAmount = Utils.getAttributedAmount(payment.transactionDetails.totalPaidAmount, thousandSeparator: String(currency.thousandsSeparator), decimalSeparator: String(currency.decimalSeparator), currencySymbol: String(currency.symbol), color: UIColor(red: 102, green: 102, blue: 102))
        title.appendAttributedString(attributedAmount)
        title.appendAttributedString(NSMutableAttributedString(string : " a MercadoPago".localized))
        return title
    }
    
    
}
