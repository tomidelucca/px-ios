//
//  HeaderComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/18/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit


open class HeaderComponent: NSObject {

    var props : HeaderProps

    init(props: HeaderProps) {
        self.props = props
    }
}


open class HeaderProps: NSObject {
    var labelText: NSAttributedString?
    var title: NSAttributedString
    var backgroundColor: UIColor
    var productImage: UIImage?
    var statusImage: UIImage?
    init(labelText: NSAttributedString?, title: NSAttributedString, backgroundColor: UIColor, productImage: UIImage?, statusImage: UIImage? ) {
        self.labelText = labelText
        self.title = title
        self.backgroundColor = backgroundColor
        self.productImage = productImage
        self.statusImage = statusImage
    }
}
