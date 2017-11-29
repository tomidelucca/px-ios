//
//  PXInstructionsSecondaryInfoComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

public class PXInstructionsSecondaryInfoComponent: NSObject, PXComponetizable {
    var props: SecondaryInfoProps

    init(props: SecondaryInfoProps) {
        self.props = props
    }
    public func render() -> UIView {
        return InstructionsSecondaryInfoRenderer().render(instructionsSecondaryInfo: self)
    }
}
public class SecondaryInfoProps: NSObject {
    var secondaryInfo: [String]
    init(secondaryInfo: [String]) {
        self.secondaryInfo = secondaryInfo
    }
}
