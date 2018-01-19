//
//  PXThemeProperty.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 10/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

open class PXThemeProperty: NSObject {
    var backgroundColor: UIColor = .clear
    var tintColor: UIColor = .clear
    public init (backgroundColor: UIColor, tintColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
    }
}
