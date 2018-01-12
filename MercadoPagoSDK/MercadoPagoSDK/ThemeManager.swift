//
//  ThemeManager.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 10/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

class ThemeManager {
    fileprivate var currentTheme: PXTheme = PXDefaultTheme() {
        didSet {
            initialize()
        }
    }
    static let shared = ThemeManager()
}

//MARK: - Public methods
extension ThemeManager {
    
    func initialize() {
        customizeNavigationBar(theme: currentTheme)
        customizeButtons(theme: currentTheme)
        customizeToolBar(theme: currentTheme)
    }
    
    func setDefaultColor(color: UIColor) {
        let customTheme = PXDefaultTheme(withPrimaryColor: color)
        self.currentTheme = customTheme
    }
        
    func setTheme(theme: PXTheme?) {
        if let currentTheme = theme {
            self.currentTheme = currentTheme
        }
    }
    
    func getTheme() -> PXTheme {
        return currentTheme
    }
    
    func getMainColor() -> UIColor {
        if let theme = currentTheme as? PXDefaultTheme {
            if let mainColor = theme.primaryColor {
                return mainColor
            }
        }
        return currentTheme.navigationBar().backgroundColor
    }
    
    func getTintColorForIcons() -> UIColor? {
        if let currentTheme = ThemeManager.shared.getTheme() as? PXDefaultTheme, let colorForIcons = currentTheme.primaryColor {
            return colorForIcons
        }
        return nil
    }
}

//MARK: - UI Theme customization
extension ThemeManager {
    fileprivate func customizeNavigationBar(theme: PXTheme) {
        UINavigationBar.appearance(whenContainedInInstancesOf: [MercadoPagoUIViewController.self]).tintColor = theme.navigationBar().tintColor
        UINavigationBar.appearance(whenContainedInInstancesOf: [MercadoPagoUIViewController.self]).backgroundColor = theme.navigationBar().backgroundColor
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [MercadoPagoUIViewController.self]).tintColor = theme.navigationBar().tintColor
        PXNavigationHeaderLabel.appearance().textColor = theme.navigationBar().tintColor
    }
    
    fileprivate func customizeButtons(theme: PXTheme) {
        PXPrimaryButton.appearance().backgroundColor = theme.primaryButton().backgroundColor
        PXPrimaryButton.appearance().setTitleColor(theme.primaryButton().tintColor, for: .normal)
        
        PXSecondaryButton.appearance().backgroundColor = theme.secondaryButton().backgroundColor
        PXSecondaryButton.appearance().setTitleColor(theme.secondaryButton().tintColor, for: .normal)
    }

    fileprivate func customizeToolBar(theme: PXTheme) {
        PXToolbar.appearance().tintColor = theme.secondaryButton().tintColor
        PXToolbar.appearance().backgroundColor = theme.secondaryButton().backgroundColor
        PXToolbar.appearance().alpha = 1
    }
}
