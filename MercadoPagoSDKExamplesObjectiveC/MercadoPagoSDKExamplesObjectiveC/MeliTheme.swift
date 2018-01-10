//
//  MeliTheme.swift
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Juan sebastian Sanzone on 10/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

@objc public class MeliTheme: NSObject, PXTheme {
    
    public func navigationBar() -> PXThemeProperty {
        return PXThemeProperty(backgroundColor: #colorLiteral(red: 1, green: 0.9450980392, blue: 0.3490196078, alpha: 1), tintColor: #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1))
    }
    
    public func primaryButton() -> PXThemeProperty {
        return PXThemeProperty(backgroundColor: #colorLiteral(red: 0.2039215686, green: 0.5137254902, blue: 0.9803921569, alpha: 1), tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    public func secondaryButton() -> PXThemeProperty {
        return PXThemeProperty(backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), tintColor: #colorLiteral(red: 0.2039215686, green: 0.5137254902, blue: 0.9803921569, alpha: 1))
    }
    
    public func titleTintColor() -> UIColor {
        return #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
    }
    
    public func subTitleTintColor() -> UIColor {
        return #colorLiteral(red: 0.3005136847, green: 0.2987321615, blue: 0.3018867671, alpha: 1)
    }
    
    public func successColor() -> UIColor {
        return #colorLiteral(red: 0.231372549, green: 0.7607843137, blue: 0.5019607843, alpha: 1)
    }
    
    public func warningColor() -> UIColor {
        return #colorLiteral(red: 1, green: 0.631372549, blue: 0.3529411765, alpha: 1)
    }
    
    public func rejectedColor() -> UIColor {
        return #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 1)
    }
    
    public func statusBarStyle() -> UIStatusBarStyle {
        return .default
    }
}
