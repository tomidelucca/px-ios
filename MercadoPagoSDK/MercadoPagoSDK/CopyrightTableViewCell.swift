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
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func drawBottomLine(width : CGFloat){
        let overLinewView = UIView(frame: CGRect(x: 20, y: 0, width: width-40, height: 1))
        overLinewView.backgroundColor = UIColor().UIColorFromRGB(0xDEDEDE)
        self.addSubview(overLinewView)
    }
    
    func drawCell(buttonHidden : Bool, width : CGFloat) -> UITableViewCell {
        self.cancelButton.hidden = buttonHidden
        self.drawBottomLine(width)
        return self
    }
}
