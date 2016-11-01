//
//  CallFourAuthTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/31/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class CallForAuthTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func addSeparatorLineToTop(width: Double, y: Int){
        var lineFrame = CGRect(origin: CGPoint(x: 0,y :y), size: CGSize(width: width, height: 0.5))
        var line = UIView(frame: lineFrame)
        line.alpha = 0.6
        line.backgroundColor = UIColor(red: 153, green: 153, blue: 153)
        addSubview(line)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
