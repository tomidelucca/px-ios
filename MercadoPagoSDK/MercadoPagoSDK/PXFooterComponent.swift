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
        return PXFooterRenderer().render(self)
    }
}
class PXFooterProps: NSObject {
    var buttonAction: PXFooterAction?
    var linkAction: PXFooterAction?
    var primaryColor: UIColor?
    init(buttonAction: PXFooterAction? = nil, linkAction: PXFooterAction? = nil, primaryColor: UIColor? = .pxBlueMp) {
        self.buttonAction = buttonAction
        self.linkAction = linkAction
        self.primaryColor = primaryColor
    }
}

class PXFooterAction: NSObject {
    var label: String
    var action : (() -> Void)
    init(label: String, action:  @escaping (() -> Void)) {
        self.label = label
        self.action = action
    }
}
