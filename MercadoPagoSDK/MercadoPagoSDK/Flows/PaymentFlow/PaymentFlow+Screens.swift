//
//  PaymentFlow+Screens.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 18/07/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

/** :nodoc: */
extension PXPaymentFlow {
    func showPaymentProcessor(paymentProcessor: PXPaymentProcessor?) {
        guard let paymentProcessor = paymentProcessor else {
            return
        }

        let containerVC = PXPaymentProcessorViewController()

        // By feature definition. Back is not available in make payment plugin.
        containerVC.shouldShowBackArrow = false

        model.assignToCheckoutStore()

        // Create navigation handler.
        paymentProcessor.paymentNavigationHandler?(navigationHandler: PXPaymentPluginNavigationHandler(flow: self))

        if let paymentView = paymentProcessor.paymentProcessorView() {
            paymentView.removeFromSuperview()
            paymentView.frame = containerVC.view.frame
            paymentView.backgroundColor = ThemeManager.shared.highlightBackgroundColor()
            containerVC.view.addSubview(paymentView)
        }

        containerVC.view.backgroundColor = ThemeManager.shared.highlightBackgroundColor()

        self.pxNavigationHandler.navigationController.pushViewController(containerVC, animated: false)
    }
}
