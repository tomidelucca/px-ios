//
//  PXPluginComponent.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 12/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

/** :nodoc: */
@objc public protocol PXConfigPluginComponent: PXPluginComponent {
    @objc optional func shouldSkip(pluginStore: PXCheckoutStore) -> Bool
    @objc optional func shouldShowBackArrow() -> Bool
}

/** :nodoc: */
@objc public protocol PXPluginComponent: NSObjectProtocol {
    func render(store: PXCheckoutStore, theme: PXTheme) -> UIView?
    @objc optional func didReceive(checkoutStore: PXCheckoutStore)
    @objc optional func renderDidFinish()
    @objc optional func viewWillAppear()
    @objc optional func viewWillDisappear()
    @objc optional func navigationHandler(navigationHandler: PXPluginNavigationHandler)
    @objc optional func titleForNavigationBar() -> String?
    @objc optional func colorForNavigationBar() -> UIColor?
    @objc optional func shouldShowNavigationBar() -> Bool
}
