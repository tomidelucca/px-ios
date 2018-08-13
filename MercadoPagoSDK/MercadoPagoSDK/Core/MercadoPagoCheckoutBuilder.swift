//
//  MercadoPagoCheckoutBuilder.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 9/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

@objcMembers
open class MercadoPagoCheckoutBuilder: NSObject {
    internal let publicKey: String
    internal var preferenceId: String?
    internal var checkoutPreference: CheckoutPreference?
    internal var paymentConfig: PXPaymentConfiguration?

    open var privateKey: String?
    open var advancedConfig: PXAdvancedConfigurationProtocol?

    open var theme: PXTheme?
    open var defaultColor: UIColor?

    open var paymentPlugin: PXPaymentPluginComponent?
    open var paymentMethodPlugins: [PXPaymentMethodPlugin] = [PXPaymentMethodPlugin]()

    public init(publicKey: String, checkoutPreference: CheckoutPreference) {
        self.publicKey = publicKey
        self.checkoutPreference = checkoutPreference
    }

    public init(publicKey: String, preferenceId: String) {
        self.publicKey = publicKey
        self.preferenceId = preferenceId
    }
}

// MARK: - Builder
extension MercadoPagoCheckoutBuilder {
    open func setLanguage(string: String) -> MercadoPagoCheckoutBuilder {
        MercadoPagoContext.setLanguage(string: string) //TODO: MercadoPagoContext (Internal refactor)
        return self
    }

    open func setPaymentConfiguration(paymentConfiguration: PXPaymentConfiguration) -> MercadoPagoCheckoutBuilder {
        paymentConfig = paymentConfiguration
        return self
    }
}
