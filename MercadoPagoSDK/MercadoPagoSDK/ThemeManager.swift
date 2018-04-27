//
//  ThemeManager.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 10/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MLUI

class ThemeManager {

    static let shared = ThemeManager()

    fileprivate var currentTheme: PXTheme = PXDefaultTheme() {
        didSet {
            initialize()
        }
    }
  
    fileprivate var currentStylesheet = MLStyleSheetManager.styleSheet
    fileprivate let fontName: String = ".SFUIDisplay-Regular"
    fileprivate let fontLightName: String = ".SFUIDisplay-Light"

    var navigationControllerMemento: NavigationControllerMemento?
}

// MARK: - Public methods
extension ThemeManager {

    func initialize() {
        currentStylesheet = MLStyleSheetManager.styleSheet
        customizeNavigationBar(theme: currentTheme)
        customizeToolBar(tintColor: getMainColor(), backgroundColor: currentStylesheet.greyColor)
            PXMonospaceLabel.appearance().font = UIFont(name: "Courier-Bold", size: 50.0)
    }

    func setDefaultColor(color: UIColor) {
        let customTheme = PXDefaultTheme(withPrimaryColor: color)
        self.currentTheme = customTheme
    }

    func setTheme(theme: PXTheme?) {
        if let currentTheme = theme {
            self.currentTheme = currentTheme
            if let externalFont = currentTheme.fontName?() {
                fontName = externalFont
            }
            if let externalLightFont = currentTheme.lightFontName?() {
                fontLightName = externalLightFont
            }
        }
    }

    func getCurrentTheme() -> PXTheme {
        return currentTheme
    }

    func getFontName() -> String {
        return fontName
    }

    func getLightFontName() -> String {
        return fontLightName
    }
}

extension ThemeManager {

    func placeHolderColor() -> UIColor {
        return UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.0)
    }

    func boldLabelTintColor() -> UIColor {
        return currentStylesheet.darkGreyColor
    }

    func labelTintColor() -> UIColor {
        return currentStylesheet.midGreyColor
    }

    func lightLabelTintColor() -> UIColor {
        return currentStylesheet.lightGreyColor
    }

    func greyColor() -> UIColor {
        return currentStylesheet.greyColor
    }

    func whiteColor() -> UIColor {
        return currentStylesheet.whiteColor
    }

    func rejectedColor() -> UIColor {
        return currentStylesheet.errorColor
    }

    func successColor() -> UIColor {
        return currentStylesheet.secondaryColor
    }

    func secondaryColor() -> UIColor {
        return currentStylesheet.secondaryColor
    }
}

// MARK: - UI design exceptions
extension ThemeManager: PXTheme {

    func navigationBar() -> PXThemeProperty {
        return currentTheme.navigationBar()
    }

    func loadingComponent() -> PXThemeProperty {
        return currentTheme.loadingComponent()
    }

    func noTaxAndDiscountLabelTintColor() -> UIColor {
        return currentTheme.noTaxAndDiscountLabelTintColor()
    }

    func warningColor() -> UIColor {
        return currentTheme.warningColor()
    }

    func highlightBackgroundColor() -> UIColor {
        return currentTheme.highlightBackgroundColor()
    }

    func detailedBackgroundColor() -> UIColor {
        return currentTheme.detailedBackgroundColor()
    }

    func statusBarStyle() -> UIStatusBarStyle {
        return currentTheme.statusBarStyle()
    }

    func getMainColor() -> UIColor {
        if let theme = currentTheme as? PXDefaultTheme, let mainColor = theme.primaryColor {
            return mainColor
        }
        return currentTheme.navigationBar().backgroundColor
    }

    func getTintColorForIcons() -> UIColor? {
        if currentStylesheet is MLStyleSheetDefault {
            return getMainColor()
        }
        return nil
    }

    func getTitleColorForReviewConfirmNavigation() -> UIColor {
        if currentTheme is PXDefaultTheme {
            return currentTheme.navigationBar().backgroundColor
        }
        return currentTheme.navigationBar().tintColor
    }

    func modalComponent() -> PXThemeProperty {
        return PXThemeProperty(backgroundColor: currentStylesheet.modalBackgroundColor, tintColor: currentStylesheet.modalTintColor, selectedColor: .clear)
    }
}

// MARK: - UI Theme customization
extension ThemeManager {

    fileprivate func customizeNavigationBar(theme: PXTheme) {
        UINavigationBar.appearance(whenContainedInInstancesOf: [MercadoPagoUIViewController.self]).tintColor = theme.navigationBar().tintColor
        UINavigationBar.appearance(whenContainedInInstancesOf: [MercadoPagoUIViewController.self]).backgroundColor = theme.navigationBar().backgroundColor
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [MercadoPagoUIViewController.self]).tintColor = theme.navigationBar().tintColor
        PXNavigationHeaderLabel.appearance().textColor = theme.navigationBar().tintColor
    }

    fileprivate func customizeToolBar(tintColor:UIColor, backgroundColor: UIColor) {
        PXToolbar.appearance().tintColor = tintColor
        PXToolbar.appearance().backgroundColor = backgroundColor
        PXToolbar.appearance().alpha = 1
    }
}
