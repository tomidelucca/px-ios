//
//  MeliTheme.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoSDK

@objc class MeliTheme: NSObject, PXTheme {

    public func navigationBar() -> PXThemeProperty {
        return PXThemeProperty(backgroundColor: #colorLiteral(red: 1, green: 0.9176470588, blue: 0.4705882353, alpha: 1), tintColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), selectedColor: .clear)
    }

    public func noTaxAndDiscountLabelTintColor() -> UIColor {
        return #colorLiteral(red: 0.2235294118, green: 0.7098039216, blue: 0.2901960784, alpha: 1)
    }

    public func warningColor() -> UIColor {
        return #colorLiteral(red: 0.9843137255, green: 0.6705882353, blue: 0.3764705882, alpha: 1)
    }

    public func loadingComponent() -> PXThemeProperty {
        return PXThemeProperty(backgroundColor: #colorLiteral(red: 1, green: 0.9176470588, blue: 0.4705882353, alpha: 1), tintColor: #colorLiteral(red: 0.2039215686, green: 0.5137254902, blue: 0.9803921569, alpha: 1), selectedColor: .clear)
    }

    public func highlightBackgroundColor() -> UIColor {
        return #colorLiteral(red: 1, green: 0.9176470588, blue: 0.4705882353, alpha: 1)
    }

    public func detailedBackgroundColor() -> UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    public func statusBarStyle() -> UIStatusBarStyle {
        return .default
    }
}
