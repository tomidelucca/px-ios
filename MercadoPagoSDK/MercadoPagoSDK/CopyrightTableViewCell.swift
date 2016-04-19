//
//  CopyrightTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 17/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CopyrightTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelButton: MPButton!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.cancelButton.addTarget(self, action: "cancelPaymentVault", forControlEvents: .TouchUpInside)
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func cancelPaymentVault(){
        MPFlowController.dismiss(true)
    }
    
    internal func drawBottomLine(width : CGFloat){
        let overLinewView = UIView(frame: CGRect(x: 0, y: 15, width: width, height: 1))
        overLinewView.backgroundColor = UIColor().UIColorFromRGB(0xDEDEDE)
        self.addSubview(overLinewView)
    }
    
}
