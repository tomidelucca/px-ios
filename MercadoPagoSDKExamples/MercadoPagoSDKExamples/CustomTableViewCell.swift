//
//  CustomTableViewCell.swift
//  MercadoPagoSDKExamples
//
//  Created by Eden Torres on 2/6/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

open class CustomTableViewCell: MPCustomTableViewCell {
    //var imageDelegate: bundle.CellProtocol?
    @IBOutlet weak var title: UILabel!
    
    open static var titleText = "Numero de telefono"

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fillCell(text: CustomTableViewCell.titleText)
    }
    
    func fillCell(text: String){
        title.text = text
    }
    
    func setTitle(text: String){
        CustomTableViewCell.titleText = text
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
