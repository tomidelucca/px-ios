//
//  InstructionsSubtitleComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation


public class InstructionsSubtitleComponent: NSObject, PXComponetizable{
    var props: InstructionsSubtitleProps

    init(props: InstructionsSubtitleProps) {
        self.props = props
    }

    public func render() -> UIView {
        return InstructionsSubtitleRenderer().render(instructionsSubtitle: self)
    }
}
public class InstructionsSubtitleProps: NSObject {
    var subtitle: String
    init(subtitle: String) {
        self.subtitle = subtitle
    }
}
