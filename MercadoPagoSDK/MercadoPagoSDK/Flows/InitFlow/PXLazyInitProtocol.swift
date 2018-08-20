//
//  PXLazyInitProtocol.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 16/7/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

@objc public protocol PXLazyInitProtocol: NSObjectProtocol {
    func didFinish(checkout: MercadoPagoCheckout)
    func failure(checkout: MercadoPagoCheckout)
}
