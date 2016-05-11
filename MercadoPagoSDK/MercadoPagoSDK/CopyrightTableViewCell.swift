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
        ViewUtils.drawBottomLine(0, width : width, inView: self)
    }
    
    func drawCell(buttonHidden : Bool, width : CGFloat) -> UITableViewCell {
        self.cancelButton.hidden = buttonHidden
        self.drawBottomLine(width)
        return self
    }
}
