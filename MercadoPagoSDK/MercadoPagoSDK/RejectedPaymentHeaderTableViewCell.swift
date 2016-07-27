//
//  RejectedPaymentTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class RejectedPaymentHeaderTableViewCell: UITableViewCell, CongratsFillmentDelegate {
    
    
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
    }
    
    func fillCell(payment : Payment, paymentMethod : PaymentMethod, callback : (Void -> Void)?) -> UITableViewCell {
        
        var title = (payment.statusDetail + "_title")
        if !title.existsLocalized() {
            title = "Uy, no pudimos procesar el pago".localized
        }
        
        let titleWithParams = (title.localized as NSString).stringByReplacingOccurrencesOfString("%0", withString: "\(paymentMethod.name.localized)")
        self.title.text = titleWithParams
        
        var subtitle = (payment.statusDetail + "_subtitle_" + paymentMethod.paymentTypeId)
        if !subtitle.existsLocalized() {
            subtitle = "Algún dato es incorrecto.".localized
        }
        
        let subtitleWithParams = (subtitle.localized as NSString).stringByReplacingOccurrencesOfString("%0", withString: "\(paymentMethod.name.localized)")
        self.subtitle.text = subtitleWithParams
        return self
    }
 
    func getCellHeight(payment : Payment, paymentMethod : PaymentMethod) -> CGFloat {
        
        var constraintSize = CGSize()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        constraintSize.width = screenSize.width - 46
        
        let attributes = [NSFontAttributeName: UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 14)!]
        
        let subtitle = ((payment.statusDetail + "_subtitle_" + paymentMethod.paymentTypeId).localized  as NSString).stringByReplacingOccurrencesOfString("%0", withString: "\(paymentMethod.name)")

        let frame = (subtitle as NSString).boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let stringSize = frame.size
        return 180 + stringSize.height
        
        
    }
    
}
