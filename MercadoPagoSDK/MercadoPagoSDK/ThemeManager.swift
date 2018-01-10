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
        customizeButtons(theme: currentTheme)
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
}

//MARK: - UI Theme customization
extension ThemeManager {
    fileprivate func customizeButtons(theme: PXTheme) {
        UIButton.appearance().backgroundColor = theme.primaryButton().backgroundColor
        UIButton.appearance().tintColor = theme.primaryButton().tintColor
    }
}
