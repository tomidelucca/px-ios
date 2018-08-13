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

    internal var privateKey: String?

    internal var paymentConfig: PXPaymentConfiguration?
    internal var advancedConfig: PXAdvancedConfigurationProtocol?

    internal var theme: PXTheme?
    internal var defaultColor: UIColor?

    internal var paymentPlugin: PXPaymentPluginComponent?
    internal var paymentMethodPlugins: [PXPaymentMethodPlugin] = [PXPaymentMethodPlugin]()

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
    open func setPrivateKey(key: String) -> MercadoPagoCheckoutBuilder {
        self.privateKey = key
        return self
    }

    open func setPaymentConfiguration(config: PXPaymentConfiguration) -> MercadoPagoCheckoutBuilder {
        self.paymentConfig = config
        return self
    }

    open func setAdvancedConfiguration(configProtocol: PXAdvancedConfigurationProtocol) -> MercadoPagoCheckoutBuilder {
        self.advancedConfig = configProtocol
        return self
    }

    open func setPaymentProcessor(paymentPlugin: PXPaymentPluginComponent) -> MercadoPagoCheckoutBuilder {
        self.paymentPlugin = paymentPlugin
        return self
    }

    open func addPaymentMethodPlugin(plugin: PXPaymentMethodPlugin) -> MercadoPagoCheckoutBuilder {
        self.paymentMethodPlugins.append(plugin)
        return self
    }

    open func setTheme(customTheme: PXTheme) -> MercadoPagoCheckoutBuilder {
        self.theme = customTheme
        return self
    }

    open func setDefaultColor(customColor: UIColor) -> MercadoPagoCheckoutBuilder {
        self.defaultColor = customColor
        return self
    }

    open func setLanguage(string: String) -> MercadoPagoCheckoutBuilder {
        MercadoPagoContext.setLanguage(string: string) //TODO: MercadoPagoContext (Internal refactor)
        return self
    }
}
