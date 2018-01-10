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
    
    func titleTintColor() -> UIColor
    func subTitleTintColor() -> UIColor
    
    func successColor() -> UIColor
    func warningColor() -> UIColor
    func rejectedColor() -> UIColor
    
    func statusBarStyle() -> UIStatusBarStyle
}
