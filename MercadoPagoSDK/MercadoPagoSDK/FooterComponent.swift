//
//  FooterComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class FooterComponent: NSObject {
  var data: FooterData
    init(data: FooterData) {
        self.data = data
    }

}
class FooterData: NSObject {
    var buttonAction: FooterAction?
    var linkAction: FooterAction?
    var primaryColor : UIColor?
    init(buttonAction: FooterAction? = nil, linkAction: FooterAction? = nil, primaryColor: UIColor? = .pxBlueMp) {
        self.buttonAction = buttonAction
        self.linkAction = linkAction
        self.primaryColor = primaryColor
    }
}

class FooterAction: NSObject {
    var label: String
    var action : (() -> Void)
    init(label: String, action:  @escaping (() -> Void)) {
        self.label = label
        self.action = action
    }
}
