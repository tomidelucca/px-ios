//
//  PXPaymentProcessor.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 23/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

@objc public protocol PXPaymentProcessor: NSObjectProtocol {
    func paymentProcessorView() -> UIView?
    @objc optional func support(checkoutStore: PXCheckoutStore) -> Bool
    @objc optional func createPayment(checkoutStore: PXCheckoutStore, handler: PXPaymentFlowHandlerProtocol, successWithBusinessResult: @escaping ((PXBusinessResult) -> Void), successWithPaymentResult: @escaping  ((PXPaymentPluginResult) -> Void))
    @objc optional func paymentNavigationHandler(navigationHandler: PXPaymentPluginNavigationHandler)
    @objc optional func paymentTimeOut() -> Double
}
