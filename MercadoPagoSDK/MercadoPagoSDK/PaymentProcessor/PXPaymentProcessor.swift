//
//  PXPaymentProcessor.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 23/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

@objc public protocol PXPaymentProcessor: NSObjectProtocol {
    @objc func paymentProcessorViewController() -> UIViewController?
    @objc func support() -> Bool
    @objc optional func didReceive(checkoutStore: PXCheckoutStore)
    @objc optional func paymentTimeOut() -> Double
    @objc optional func createPayment(checkoutStore: PXCheckoutStore, handler: PXPaymentFlowHandlerProtocol, successWithBusinessResult: @escaping ((PXBusinessResult) -> Void), successWithPaymentResult: @escaping  ((PXPaymentPluginResult) -> Void))
    @objc optional func paymentNavigationHandler(navigationHandler: PXPaymentPluginNavigationHandler)
}
