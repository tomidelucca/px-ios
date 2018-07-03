//
//  InitFlowModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 27/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServices

internal typealias InitFlowProperties = (paymentData: PaymentData, checkoutPreference: CheckoutPreference, paymentResult: PaymentResult?, paymentPlugin: PXPaymentPluginComponent?, paymentMethodPlugins: [PXPaymentMethodPlugin], paymentMethodSearchResult: PaymentMethodSearch?, loadPreferenceStatus: Bool, directDiscountSearchStatus: Bool)

internal protocol InitFlowProtocol: NSObjectProtocol {
    func didFinishInitFlow()
    func didFailInitFlow()
}

final class InitFlowModel: NSObject, PXFlowModel {
    internal enum Steps: String {
        case ERROR
        case SERVICE_GET_PREFERENCE
        case ACTION_VALIDATE_PREFERENCE
        case SERVICE_GET_DIRECT_DISCOUNT
        case SERVICE_GET_PAYMENT_METHODS
        case SERVICE_PAYMENT_METHOD_PLUGIN_INIT
        case FINISH
    }

    private let serviceAdapter = MercadoPagoServicesAdapter(servicePreference: MercadoPagoCheckoutViewModel.servicePreference)
    private let mpESCManager: MercadoPagoESC = MercadoPagoESCImplementation()

    private var preferenceValidated: Bool = false
    private var needPaymentMethodPluginInit = true
    private var errorCallback: (() -> Void)?

    var properties: InitFlowProperties

    var amountHelper: PXAmountHelper {
        get {
            return PXAmountHelper(preference: self.properties.checkoutPreference, paymentData: self.properties.paymentData, discount: self.properties.paymentData.discount, campaign: self.properties.paymentData.campaign)
        }
    }

    init(flowProperties: InitFlowProperties) {
        self.properties = flowProperties
        super.init()
    }
}

// MARK: Public methods
extension InitFlowModel {
    func getService() -> MercadoPagoServicesAdapter {
        return serviceAdapter
    }

    func getESCService() -> MercadoPagoESC {
        return mpESCManager
    }

    func setErrorInputs(error: MPSDKError, errorCallback: (() -> Void)?) {
        MercadoPagoCheckoutViewModel.error = error
        self.errorCallback = errorCallback
    }

    func paymentMethodPluginDidLoaded() {
        needPaymentMethodPluginInit = false
    }

    func getExcludedPaymentTypesIds() -> Set<String>? {
        if properties.checkoutPreference.siteId == "MLC" || properties.checkoutPreference.siteId == "MCO" ||
            properties.checkoutPreference.siteId == "MLV" {
            properties.checkoutPreference.addExcludedPaymentType("atm")
            properties.checkoutPreference.addExcludedPaymentType("bank_transfer")
            properties.checkoutPreference.addExcludedPaymentType("ticket")
        }
        return properties.checkoutPreference.getExcludedPaymentTypesIds()
    }

    func getDefaultPaymentMethodId() -> String? {
        return properties.checkoutPreference.getDefaultPaymentMethodId()
    }

    func getExcludedPaymentMethodsIds() -> Set<String>? {
        return properties.checkoutPreference.getExcludedPaymentMethodsIds()
    }

    func updateInitModel(paymentMethodsResponse: PaymentMethodSearch?) {
        properties.paymentMethodSearchResult = paymentMethodsResponse
    }

    func getPaymentMethodSearch() -> PaymentMethodSearch? {
        return properties.paymentMethodSearchResult
    }
}

// MARK: nextStep - State machine
extension InitFlowModel {
    func nextStep() -> Steps {
        if hasError() {
            return .ERROR
        }

        if needLoadPreference() {
            properties.loadPreferenceStatus = false
            return .SERVICE_GET_PREFERENCE
        }

        if needValidatePreference() {
            preferenceValidated = true
            return .ACTION_VALIDATE_PREFERENCE
        }

        if needToInitPaymentMethodPlugins() {
            return .SERVICE_PAYMENT_METHOD_PLUGIN_INIT
        }

        if needSearch() {
            return .SERVICE_GET_PAYMENT_METHODS
        }

        if needToSearchDirectDiscount() {
            properties.directDiscountSearchStatus = true
            return .SERVICE_GET_DIRECT_DISCOUNT
        }

        return .FINISH
    }
}

// MARK: Needs methods
extension InitFlowModel {
    private func needLoadPreference() -> Bool {
        return properties.loadPreferenceStatus
    }

    private func needToSearchDirectDiscount() -> Bool {
        return isDiscountEnabled() && !properties.directDiscountSearchStatus && properties.paymentData.discount == nil && properties.paymentResult == nil && !properties.paymentData.isComplete() && (properties.paymentMethodPlugins.isEmpty && properties.paymentPlugin == nil)
    }

    private func needValidatePreference() -> Bool {
        return !properties.loadPreferenceStatus && !preferenceValidated
    }

    private func needToInitPaymentMethodPlugins() -> Bool {
        if properties.paymentMethodPlugins.isEmpty {
            return false
        }
        return needPaymentMethodPluginInit
    }

    private func needSearch() -> Bool {
        return properties.paymentMethodSearchResult == nil
    }

    private func isDiscountEnabled() -> Bool {
        return MercadoPagoCheckoutViewModel.flowPreference.isDiscountEnable()
    }

    private func hasError() -> Bool {
        return MercadoPagoCheckoutViewModel.error != nil
    }
}
