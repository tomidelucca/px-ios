//
//  CustomTableViewCell.swift
//  MercadoPagoSDKExamples
//
//  Created by Eden Torres on 2/6/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoSDK
@objc
public class CustomTableViewCell: UITableViewCell, CellProtocol {
    //var imageDelegate: bundle.CellProtocol?

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
