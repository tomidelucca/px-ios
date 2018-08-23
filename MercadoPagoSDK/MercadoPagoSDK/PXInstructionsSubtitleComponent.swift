//
//  PXInstructionsSubtitleComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

internal class PXInstructionsSubtitleComponent: NSObject, PXComponentizable {
    var props: PXInstructionsSubtitleProps

    init(props: PXInstructionsSubtitleProps) {
        self.props = props
    }

    func render() -> UIView {
        return PXInstructionsSubtitleRenderer().render(self)
    }
}

internal class PXInstructionsSubtitleProps: NSObject {
    var subtitle: String

    init(subtitle: String) {
        self.subtitle = subtitle
    }
}
