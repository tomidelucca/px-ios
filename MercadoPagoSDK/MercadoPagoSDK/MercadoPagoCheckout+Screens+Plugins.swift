//
//  MercadoPagoCheckout+Screens+Plugins.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 12/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
extension MercadoPagoCheckout {
    func showPaymentMethodPluginConfigScreen() {
        guard let paymentMethodPlugin = self.viewModel.paymentOptionSelected as? PXPaymentMethodPlugin else {
            return
        }

        let containerVC = PXPluginConfigViewController()

        guard let paymentMethodConfigPluginComponent = paymentMethodPlugin.paymentMethodConfigPlugin else {
            return
        }
        containerVC.pluginComponentInterface = paymentMethodConfigPluginComponent
        containerVC.paymentMethodId = paymentMethodPlugin.getId()
        viewModel.populateCheckoutStore()
        paymentMethodConfigPluginComponent.didReceive?(checkoutStore: PXCheckoutStore.sharedInstance)

        // Create navigation handler.
        paymentMethodConfigPluginComponent.navigationHandler?(navigationHandler: PXPluginNavigationHandler(withCheckout: self))

        if let navTitle = paymentMethodConfigPluginComponent.titleForNavigationBar?() {
            containerVC.title = navTitle
        }

        if let navBarColor = paymentMethodConfigPluginComponent.colorForNavigationBar?() {
            containerVC.setNavBarBackgroundColor(color: navBarColor)
        }

        containerVC.shouldShowBackArrow = true
        if let shouldShowBackArrow = paymentMethodConfigPluginComponent.shouldShowBackArrow?() {
            containerVC.shouldShowBackArrow = shouldShowBackArrow
        }

        if let shouldShowNavigationBar = paymentMethodConfigPluginComponent.shouldShowNavigationBar?() {
            containerVC.shouldHideNavigationBar = !shouldShowNavigationBar
        }

        if let paymentMethodConfigPluginComponentView = paymentMethodConfigPluginComponent.render(store: PXCheckoutStore(), theme: ThemeManager.shared.getCurrentTheme()) {
            paymentMethodConfigPluginComponentView.removeFromSuperview()
            paymentMethodConfigPluginComponentView.frame = containerVC.view.frame
            containerVC.view.addSubview(paymentMethodConfigPluginComponentView)
        }

        paymentMethodConfigPluginComponent.renderDidFinish?()

        viewModel.pxNavigationHandler.pushViewController(viewController: containerVC, animated: true)
    }
}
