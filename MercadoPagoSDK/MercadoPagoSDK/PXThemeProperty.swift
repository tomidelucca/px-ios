//
//  PXThemeProperty.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 10/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

open class PXThemeProperty: NSObject {
    var backgroundColor: UIColor
    var tintColor: UIColor
    public init (backgroundColor: UIColor, tintColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
    }

    open func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }

    open func setTintColor(color: UIColor) {
        self.tintColor = color
    }

    open func getBackgroundColor() -> UIColor {
        return backgroundColor
    }

    open func getTintColor() -> UIColor {
        return tintColor
    }
}
