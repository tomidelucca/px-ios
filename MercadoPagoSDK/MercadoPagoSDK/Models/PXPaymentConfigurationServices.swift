//
//  PXPaymentConfigurationServices.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/11/18.
//

import UIKit

class PXPaymentConfigurationServices: NSObject {
    let configurations: Set<PXPaymentMethodConfiguration> = []
    
    // Grupos
    func getDefaultPayamentMethodConfigurations() -> [(paymentMethod: PXPaymentMethod,configuration: PXPaymentOptionConfiguration)] {
        var defaultConfigs = [(paymentMethod: PXPaymentMethod,configuration: PXPaymentOptionConfiguration)]()
        for configuration in configurations {
            if configuration.defaultConfigurationIndex < configuration.paymentOptionsConfigurations.count {
                let config = configuration.paymentOptionsConfigurations[configuration.defaultConfigurationIndex]
                defaultConfigs.append((paymentMethod: configuration.paymentMethod, configuration: config))
            }
        }
        return defaultConfigs
    }
}
