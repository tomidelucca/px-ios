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

    // Installments
    func getInstallmentsForPaymentMethod(_ paymentMethodOption: PaymentMethodOption) -> PXInstallment? {
//        if let configuration = configurations.first(where: {$0.paymentMethodOption.getId() == paymentMethodOption.getId()}) {
//            let installment = configuration.paymentOptionsConfigurations[configuration.defaultConfigurationIndex].installment
//            return installment
//        }
        return nil
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
    func getDiscountConfigurationForPaymentMethod(_ paymentMethodOption: PaymentMethodOption) -> (discount:PXDiscount, campaign:PXCampaign)? {
//        if let configuration = configurations.first(where: {$0.paymentMethodOption.getId() == paymentMethodOption.getId()}) {
//            let discountConfiguration = configuration.paymentOptionsConfigurations[configuration.defaultConfigurationIndex].discountConfiguration
//            return discountConfiguration
//        }
        return nil
    }

    // All Configurations
    func getConfigurations(forPaymentMethod paymentMethodOption: PaymentMethodOption) -> [PXPaymentOptionConfiguration]? {
//        if let config = configurations.first(where: {$0.paymentMethodOption.getId() == paymentMethodOption.getId()}) {
//            return config.paymentOptionsConfigurations
//        }
        return nil
    }

    func setConfigurations(_ configurations: Set<PXPaymentMethodConfiguration>) {
        self.configurations = configurations
    }
}
