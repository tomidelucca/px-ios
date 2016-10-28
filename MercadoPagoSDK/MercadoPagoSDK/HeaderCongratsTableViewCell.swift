//
//  HeaderCongratsTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/25/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class HeaderCongratsTableViewCell: UITableViewCell {

    @IBOutlet weak var messageError: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func fillCell(paymentStatus: String, color: UIColor){
        if paymentStatus == "approved" {
            icon.image = MercadoPago.getImage("iconoAcreditado")
            title.text = "¡Listo, se acreditó tu pago!"
            messageError.text = ""
            view.backgroundColor = color
        } else if paymentStatus == "pending" {
            icon.image = MercadoPago.getImage("congrats_iconPending")
            title.text = "Estamos procesando el pago"
            messageError.text = ""
            view.backgroundColor = color
        } else if paymentStatus == "rejected" {
            icon.image = MercadoPago.getImage("congrats_iconoTcError")
            title.text = "Mastercard no procesó el pago"
            messageError.text = "Algo salió mal… "
            view.backgroundColor = color
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
