//
//  PXPayerProps.swift
//  MercadoPagoSDK
//
//  Created by Marcelo Oscar José on 14/10/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXPayerProps: NSObject {
    let identityfication: NSAttributedString
    let fulltName: NSAttributedString
    let action: PXAction
    let backgroundColor: UIColor
    let labelColor: UIColor

    public init(identityfication: NSAttributedString, fulltName: NSAttributedString, action: PXAction, backgroundColor: UIColor, labelColor: UIColor) {
        self.identityfication = identityfication
        self.fulltName = fulltName
        self.action = action
        self.backgroundColor = backgroundColor
        self.labelColor = labelColor
    }
}
