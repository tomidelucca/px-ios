//
//  ConfirmEmailTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/26/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class ConfirmEmailTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillCell(payment: Payment) -> Void {
        if payment.status == "approved"{
            label.text = ("Te enviaremos este comprobante a %0".localized as NSString).replacingOccurrences(of: "%0", with: "\(payment.payer.email!)")
        } else {
            label.text = "También enviamos el código a tu email".localized
        }
    }
    func addSeparatorLineToTop(width: Double, y: Int){
        var lineFrame = CGRect(origin: CGPoint(x: 0,y :y), size: CGSize(width: width, height: 0.5))
        var line = UIView(frame: lineFrame)
        line.alpha = 0.6
        line.backgroundColor = UIColor.grayLight()
        addSubview(line)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
