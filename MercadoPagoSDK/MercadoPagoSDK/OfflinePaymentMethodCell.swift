//
//  PaymentMethodCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 29/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class OfflinePaymentMethodCell: UITableViewCell {

    static let ROW_HEIGHT = CGFloat(80)
    
    @IBOutlet weak var paymentMethodDescription: MPLabel!
   
    @IBOutlet weak var acreditationTimeLabel: MPLabel!

    @IBOutlet weak var changePaymentButton: MPButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func fillCell(_ paymentMethodMethodSearchItem : PaymentMethodSearchItem, amount : Double, currency : Currency) {
        // Verificar
        let paymentMethodDescription = NSMutableAttributedString(string: "Pagarás ")
        let attributedAmount = Utils.getAttributedAmount(amount, currency: currency, color : UIColor.grayBaseText())
        paymentMethodDescription.append(attributedAmount)
        paymentMethodDescription.append(NSAttributedString(string : " en un " + paymentMethodMethodSearchItem.idPaymentMethodSearchItem))
        self.paymentMethodDescription.attributedText = paymentMethodDescription
        
        self.acreditationTimeLabel.attributedText = NSMutableAttributedString(string: paymentMethodMethodSearchItem.comment!)
    }
    
  }
