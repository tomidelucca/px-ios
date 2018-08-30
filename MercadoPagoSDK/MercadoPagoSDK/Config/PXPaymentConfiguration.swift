//
//  PXPaymentConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 10/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

internal typealias PXPaymentConfigurationType = (discountConfiguration: PXDiscountConfiguration?, chargeRules: [PXPaymentTypeChargeRule]?, paymentPlugin: PXPaymentProcessor, paymentMethodPlugins: [PXPaymentMethodPlugin])

@objcMembers
open class PXPaymentConfiguration: NSObject {
    private let paymentPlugin: PXPaymentProcessor
    private var discountConfiguration: PXDiscountConfiguration?
    private var chargeRules: [PXPaymentTypeChargeRule] = [PXPaymentTypeChargeRule]()
    private var paymentMethodPlugins: [PXPaymentMethodPlugin] = [PXPaymentMethodPlugin]()

    public init(paymentProcessor: PXPaymentProcessor) {
        self.paymentPlugin = paymentProcessor
    }
}

// MARK: - Builder
extension PXPaymentConfiguration {
    open func addPaymentMethodPlugin(plugin: PXPaymentMethodPlugin) -> PXPaymentConfiguration {
        self.paymentMethodPlugins.append(plugin)
        return self
    }

    open func addChargeRules(charges: [PXPaymentTypeChargeRule]) -> PXPaymentConfiguration {
        self.chargeRules.append(contentsOf: charges)
        return self
    }

    open func setDiscountConfiguration(config: PXDiscountConfiguration) -> PXPaymentConfiguration {
        self.discountConfiguration = config
        return self
    }
}

// MARK: - Internals
extension PXPaymentConfiguration {
    internal func getPaymentConfiguration() -> PXPaymentConfigurationType {
        return (discountConfiguration, chargeRules, paymentPlugin, paymentMethodPlugins)
    }
}
