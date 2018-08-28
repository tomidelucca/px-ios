//
//  PXPaymentMethodConfigProtocol.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 12/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

@objc public protocol PXPaymentMethodConfigProtocol {
    @objc func configViewController() -> UIViewController?
    @objc func shouldSkip(store: PXCheckoutStore) -> Bool
    @objc optional func didReceive(checkoutStore: PXCheckoutStore, theme: PXTheme)
    @objc optional func navigationHandler(navigationHandler: PXPluginNavigationHandler)
}
