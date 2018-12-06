//
//  MercadopagoCheckoutViewModel+InitFlow.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 4/7/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

// MARK: Init Flow
extension MercadoPagoCheckoutViewModel {
    func createInitFlow() {
        // Create init flow props.
        let initFlowProperties: InitFlowProperties
        initFlowProperties.checkoutPreference = self.checkoutPreference
        initFlowProperties.paymentData = self.paymentData
        initFlowProperties.paymentMethodPlugins = self.paymentMethodPlugins
        initFlowProperties.paymentPlugin = self.paymentPlugin
        initFlowProperties.paymentMethodSearchResult = self.search
        initFlowProperties.chargeRules = self.chargeRules
        initFlowProperties.consumedDiscount = self.consumedDiscount
        initFlowProperties.serviceAdapter = self.mercadoPagoServicesAdapter
        initFlowProperties.advancedConfig = self.getAdvancedConfiguration()
        initFlowProperties.paymentConfigurationService = self.paymentConfigurationService

        // Create init flow.
        initFlow = InitFlow(flowProperties: initFlowProperties, finishCallback: { [weak self] (checkoutPreference, paymentMethodSearchResponse)  in
            self?.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchResponse)
            PXTrackingStore.sharedInstance.addData(forKey: PXTrackingStore.cardIdsESC, value: self?.getCardsIdsWithESC() ?? [])
            self?.checkoutPreference = checkoutPreference

            let selectedDiscountConfigurartion = paymentMethodSearchResponse.selectedDiscountConfiguration
            self?.attemptToApplyDiscount(discountConfiguration: selectedDiscountConfigurartion)

            self?.initFlowProtocol?.didFinishInitFlow()
        }, errorCallback: { [weak self] initFlowError in
            self?.initFlowProtocol?.didFailInitFlow(flowError: initFlowError)
        })
    }

    func setInitFlowProtocol(flowInitProtocol: InitFlowProtocol) {
        initFlowProtocol = flowInitProtocol
    }

    func startInitFlow() {
        initFlow?.start()
    }

    func updateInitFlow() {
        initFlow?.updateModel(paymentPlugin: self.paymentPlugin, paymentMethodPlugins: self.paymentMethodPlugins)
    }

    func attemptToApplyDiscount(discountConfiguration: PXDiscountConfiguration?) {
        if let discountConfiguration = discountConfiguration {

            if let discount = discountConfiguration.getDiscountConfiguration().discount, let campaign = discountConfiguration.getDiscountConfiguration().campaign {
                self.setDiscount(discount, withCampaign: campaign)
            }

            if discountConfiguration.getDiscountConfiguration().isNotAvailable {
                self.clearDiscount()
                self.consumedDiscount = true
            }

        }
    }
}
