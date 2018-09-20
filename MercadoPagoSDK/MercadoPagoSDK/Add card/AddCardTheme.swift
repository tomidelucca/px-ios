//
//  AddCardTheme.swift
//  MercadoPagoSDKV4
//
//  Created by Diego Flores Domenech on 20/9/18.
//

import UIKit
import MLUI

class AddCardTheme: PXTheme {
    func navigationBar() -> PXThemeProperty {
        return PXThemeProperty(backgroundColor: MLStyleSheetManager.styleSheet.primaryColor, tintColor: MLStyleSheetManager.styleSheet.whiteColor)
    }
    
    func loadingComponent() -> PXThemeProperty {
        return PXThemeProperty(backgroundColor: MLStyleSheetManager.styleSheet.primaryColor, tintColor: MLStyleSheetManager.styleSheet.whiteColor)
    }
    
    func highlightBackgroundColor() -> UIColor {
        return MLStyleSheetManager.styleSheet.primaryColor
    }
    
    func detailedBackgroundColor() -> UIColor {
        return UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
    }
    
    func statusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
    func fontName() -> String? {
        return "ProximaNova-Regular"
    }
    
    func lightFontName() -> String? {
        return "ProximaNova-Light"
    }
    
    func semiBoldFontName() -> String? {
        return "ProximaNova-Semibold"
    }
    
}
