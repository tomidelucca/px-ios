//
//  PXFooterComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class PXFooterComponent: NSObject, PXComponetizable {
  var props: PXFooterProps

    init(props: PXFooterProps) {
        self.props = props
    }

    func render() -> UIView {
        return FooterRenderer().render(footer: self)
    }
}
class PXFooterProps: NSObject {
    var buttonAction: FooterAction?
    var linkAction: FooterAction?
    var primaryColor: UIColor?
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
