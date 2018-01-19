//
//  PXTheme.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 9/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

@objc public protocol PXTheme {
    func navigationBar() -> PXThemeProperty
    func primaryButton() -> PXThemeProperty
    func secondaryButton() -> PXThemeProperty

    func labelTintColor() -> UIColor
    func lightLabelTintColor() -> UIColor
    func boldLabelTintColor() -> UIColor

    func successColor() -> UIColor
    func warningColor() -> UIColor
    func rejectedColor() -> UIColor
    func discountColor() -> UIColor

    func loadingComponent() -> PXThemeProperty
    func modalComponent() -> PXThemeProperty

    func highlightBackgroundColor() -> UIColor
    func detailedBackgroundColor() -> UIColor
    func circleBackgroundColor() -> UIColor

    func statusBarStyle() -> UIStatusBarStyle
}
