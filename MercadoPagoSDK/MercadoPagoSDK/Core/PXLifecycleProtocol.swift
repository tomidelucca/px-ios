//
//  PXLifecycleProtocol.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 29/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

@objc public protocol PXLifeCycleProtocol: NSObjectProtocol {
    @objc func cancelCheckout() -> (() -> Void)?
    @objc func finishCheckout(payment: PXPayment?) -> (() -> Void)?
}
