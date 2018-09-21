//
//  MercadoPagoCheckout+Screens+Hooks.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 12/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

internal extension MercadoPagoCheckout {
    func showPreReviewScreen() {

        if let targetHook = viewModel.hookService.preReviewScreen {

            targetHook.navigationHandlerForHook?(navigationHandler: PXHookNavigationHandler(withCheckout: self))

            viewModel.populateCheckoutStore()
            targetHook.didReceive?(hookStore: PXCheckoutStore.sharedInstance)

            viewModel.pxNavigationHandler.pushViewController(targetVC: targetHook.configViewController(), animated: true)
        }
    }
}
