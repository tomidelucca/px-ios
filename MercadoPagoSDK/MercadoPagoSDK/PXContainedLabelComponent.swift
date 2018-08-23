//
//  PXContainedLabelComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 1/23/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

@objcMembers
internal class PXContainedLabelComponent: PXComponentizable {

    public func render() -> UIView {
        return PXContainedLabelRenderer().render(self)
    }

    var props: PXContainedLabelProps

    init(props: PXContainedLabelProps) {
        self.props = props
    }
}

@objcMembers
internal class PXContainedLabelProps: NSObject {
    var labelText: NSAttributedString
    init(labelText: NSAttributedString) {
        self.labelText = labelText
    }
}
