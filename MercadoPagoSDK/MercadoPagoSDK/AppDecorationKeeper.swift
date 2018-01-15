//
//  AppDecorationKeeper.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 2/24/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

internal class NavigationControllerMemento {
    
    var navBarTintColor: UIColor?
    var navTintColor: UIColor?
    var navTitleTextAttributes: [String: Any]?
    var navIsTranslucent: Bool = false
    var navViewBackgroundColor: UIColor?
    var navBackgroundColor: UIColor?
    var navBackgroundImage: UIImage?
    var navShadowImage: UIImage?
    var navBarStyle: UIBarStyle?

    init(navigationController: UINavigationController) {
        self.navBarTintColor =  navigationController.navigationBar.barTintColor
        self.navTintColor =  navigationController.navigationBar.tintColor
        self.navTitleTextAttributes = navigationController.navigationBar.titleTextAttributes
        self.navIsTranslucent = navigationController.navigationBar.isTranslucent
        self.navViewBackgroundColor = navigationController.view.backgroundColor
        self.navBackgroundColor = navigationController.navigationBar.backgroundColor
        self.navBackgroundImage = navigationController.navigationBar.backgroundImage(for: .default)
        self.navShadowImage = navigationController.navigationBar.shadowImage
        self.navBarStyle = navigationController.navigationBar.barStyle
    }
}
