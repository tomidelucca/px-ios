//
//  PXPaymentConfigurationServices.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/11/18.
//

import UIKit

class PXPaymentConfigurationServices {
    
    private var configurations: Set<PXPaymentMethodConfiguration> = []

    // Payer Costs for Payment Method
    func getPayerCostsForPaymentMethod(_ id: String) -> [PXPayerCost]? {
        if let configuration = configurations.first(where: {$0.paymentOptionID == id}) {
            if let paymentOptionConfiguration = configuration.paymentOptionsConfigurations.first(where: {$0.id == configuration.selectedAmountConfiguration}) {
                return paymentOptionConfiguration.payerCostConfiguration?.payerCosts
            }
        }
        return nil
    }

    // Selected Payer Cost for Payment Method
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

    func setConfigurations(_ configurations: Set<PXPaymentMethodConfiguration>) {
        self.configurations = configurations
    }
}
