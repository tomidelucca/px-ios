//
//  PXDefaultTheme.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 10/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

class PXDefaultTheme: NSObject {
    var primaryColor: UIColor?
    
    override init() {
        super.init()
    }
    
    public init(withPrimaryColor:UIColor) {
        self.primaryColor = withPrimaryColor
    }
}

//MARK: - Theme styles.
extension PXDefaultTheme: PXTheme {
    
    public func navigationBar() -> PXThemeProperty {
        var themeProperty = PXThemeProperty(backgroundColor: #colorLiteral(red: 0, green: 0.5411764706, blue: 0.8392156863, alpha: 1), tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        if let customColor = primaryColor {
           themeProperty = PXThemeProperty(backgroundColor: customColor, tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
        return themeProperty
    }
    
    public func primaryButton() -> PXThemeProperty {
        var themeProperty = PXThemeProperty(backgroundColor: #colorLiteral(red: 0, green: 0.5411764706, blue: 0.8392156863, alpha: 1), tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        if let customColor = primaryColor {
            themeProperty = PXThemeProperty(backgroundColor: customColor, tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
        return themeProperty
    }
    
    public func secondaryButton() -> PXThemeProperty {
        var themeProperty = PXThemeProperty(backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), tintColor:#colorLiteral(red: 0, green: 0.5411764706, blue: 0.8392156863, alpha: 1))
        if let customColor = primaryColor {
            themeProperty = PXThemeProperty(backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), tintColor: customColor)
        }
        return themeProperty
    }
    
    public func labelTintColor() -> UIColor {
        return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    public func boldLabelTintColor() -> UIColor {
        return #colorLiteral(red: 0.1978237927, green: 0.2149228156, blue: 0.2378431559, alpha: 1)
    }
    
    public func successColor() -> UIColor {
        return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    }
    
    public func warningColor() -> UIColor {
        return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    }
    
    public func rejectedColor() -> UIColor {
        return #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    public func statusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
}
