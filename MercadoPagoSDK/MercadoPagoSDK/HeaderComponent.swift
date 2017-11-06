//
//  HeaderComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/18/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class HeaderComponent: NSObject {
    var labelText : NSAttributedString?
    var title : NSAttributedString
    var backgroundColor : UIColor
    var productImage : UIImage?
    var statusImage : UIImage?
    
    init(data : HeaderData) {
        self.labelText = data.labelText
        self.title = data.title
        self.backgroundColor = data.backgroundColor
        self.productImage = data.productImage
        self.statusImage = data.statusImage
    }
}
class HeaderData : NSObject {
    var labelText : NSAttributedString?
    var title : NSAttributedString
    var backgroundColor : UIColor
    var productImage : UIImage?
    var statusImage : UIImage?
    init(labelText: NSAttributedString?, title: NSAttributedString, backgroundColor: UIColor,productImage:UIImage?, statusImage : UIImage? ) {
        self.labelText = labelText
        self.title = title
        self.backgroundColor = backgroundColor
        self.productImage = productImage
        self.statusImage = statusImage
    }
}


