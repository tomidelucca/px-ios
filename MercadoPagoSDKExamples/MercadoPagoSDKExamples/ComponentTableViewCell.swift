//
//  ComponentTableViewCell.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 29/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class ComponentTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func initializeWith(iconImage: String, title: String){
        var image = UIImage(named: iconImage)
        image = image?.imageWithRenderingMode(.AlwaysTemplate)
        self.icon.image = image
        self.icon.tintColor = UIColor().blueMercadoPago()
        self.title.text = title
    }
    
}
