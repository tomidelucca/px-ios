//
//  PXPaymentConfigurationServices.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/11/18.
//

import UIKit

class PXPaymentConfigurationServices: NSObject {
    
    internal var configurations: Set<PXPaymentMethodConfiguration> = []

    init(configurations: Set<PXPaymentMethodConfiguration>) {
        self.configurations = configurations
    }
    
    // Grupos
    func getDefaultPayamentMethodsConfigurations() -> [(paymentMethodOption: PaymentMethodOption, configuration: PXPaymentOptionConfiguration)] {
        var defaultConfigs = [(paymentMethodOption: PaymentMethodOption, configuration: PXPaymentOptionConfiguration)]()
//        for configuration in configurations {
//            if configuration.defaultConfigurationIndex < configuration.paymentOptionsConfigurations.count {
//                let config = configuration.paymentOptionsConfigurations[configuration.defaultConfigurationIndex]
//                defaultConfigs.append((paymentMethodOption: configuration.paymentMethodOption, configuration: config))
//            }
//        }
        return defaultConfigs
    }

    func getPayerCostsForPaymentMethod(_ id: String) -> [PXPayerCost]? {
        if let configuration = configurations.first(where: {$0.paymentOptionID == id}) {
            if let paymentOptionConfiguration = configuration.paymentOptionsConfigurations.first(where: {$0.id == configuration.selectedAmountConfiguration}) {
                return paymentOptionConfiguration.payerCostConfiguration?.payerCosts
            }
        }
        return nil
    }

    func getSelectedPayerCostsForPaymentMethod(_ id: String) -> PXPayerCost? {
        if let configuration = configurations.first(where: {$0.paymentOptionID == id}) {
            if let paymentOptionConfiguration = configuration.paymentOptionsConfigurations.first(where: {$0.id == configuration.selectedAmountConfiguration}) {
                return paymentOptionConfiguration.payerCostConfiguration?.selectedPayerCost
            }
        }
        return nil
    }

    // Discount Configuration
    func getDiscountConfigurationForPaymentMethod(_ id: String) -> PXDiscountConfiguration? {
        if let configuration = configurations.first(where: {$0.paymentOptionID == id}) {
            if let paymentOptionConfiguration = configuration.paymentOptionsConfigurations.first(where: {$0.id == configuration.selectedAmountConfiguration}) {
                let discountConfiguration = paymentOptionConfiguration.discountConfiguration
                return discountConfiguration
            }
        }
        return nil
    }

    // All Configurations
    func getConfigurationsForPaymentMethod(_ id: String) -> [PXPaymentOptionConfiguration]? {
        if let config = configurations.first(where: {$0.paymentOptionID == id}) {
            return config.paymentOptionsConfigurations
        }
        return nil
    }
}
