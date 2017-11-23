//
//  HeaderComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/18/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

<<<<<<< HEAD

open class HeaderComponent: NSObject {
=======
class HeaderComponent: NSObject {
>>>>>>> b2a67b37e026f37134e7a09f7fc9cb02ba448adf
    var props : HeaderProps

    init(props: HeaderProps) {
        self.props = props
    }
}
<<<<<<< HEAD

open class HeaderProps: NSObject {
=======
public class HeaderProps: NSObject {
>>>>>>> b2a67b37e026f37134e7a09f7fc9cb02ba448adf
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
