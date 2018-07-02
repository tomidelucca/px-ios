//
//  InitFlowModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 27/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServices

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
    let paymentResult: PaymentResult?
    var paymentData: PaymentData
    let paymentPlugin: PXPaymentPluginComponent?
    let paymentMethodPlugins: [PXPaymentMethodPlugin]
    var checkoutPreference: CheckoutPreference
    var paymentMethodSearch: PaymentMethodSearch?
    private var shouldLoadPreference: Bool = false
    private var directDiscountSearched: Bool = false
    private var preferenceValidated: Bool = false
    private var needPaymentMethodPluginInit = true
    private var errorCallback: (() -> Void)?
    var amountHelper: PXAmountHelper {
        get {
            return PXAmountHelper(preference: self.checkoutPreference, paymentData: self.paymentData, discount: self.paymentData.discount, campaign: self.paymentData.campaign)
        }
    }

    init(flowProperties: InitFlowProperties) {
        self.paymentData = flowProperties.paymentData.copy() as? PaymentData ?? flowProperties.paymentData
        self.checkoutPreference = flowProperties.checkoutPreference
        self.paymentResult = flowProperties.paymentResult
        self.paymentPlugin = flowProperties.paymentPlugin
        self.paymentMethodPlugins = flowProperties.paymentMethodPlugins
        self.paymentMethodSearch = flowProperties.paymentMethodSearchResult
        self.shouldLoadPreference = flowProperties.loadPreferenceStatus
        self.directDiscountSearched = flowProperties.directDiscountSearchStatus
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
        if checkoutPreference.siteId == "MLC" || checkoutPreference.siteId == "MCO" ||
            checkoutPreference.siteId == "MLV" {
            checkoutPreference.addExcludedPaymentType("atm")
            checkoutPreference.addExcludedPaymentType("bank_transfer")
            checkoutPreference.addExcludedPaymentType("ticket")
        }
        return checkoutPreference.getExcludedPaymentTypesIds()
    }

    func getDefaultPaymentMethodId() -> String? {
        return checkoutPreference.getDefaultPaymentMethodId()
    }

    func getExcludedPaymentMethodsIds() -> Set<String>? {
        return checkoutPreference.getExcludedPaymentMethodsIds()
    }

    func updateModel(paymentMethodsResponse: PaymentMethodSearch?) {
        paymentMethodSearch = paymentMethodsResponse
    }
}

// MARK: nextStep - State machine
extension InitFlowModel {
    func nextStep() -> Steps {
        if needLoadPreference() {
            shouldLoadPreference = false
            return .SERVICE_GET_PREFERENCE
        }

        if needToSearchDirectDiscount() {
            directDiscountSearched = true
            return .SERVICE_GET_DIRECT_DISCOUNT
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

        return .FINISH
    }
}

// MARK: Needs methods
extension InitFlowModel {
    private func needLoadPreference() -> Bool {
        return shouldLoadPreference
    }

    private func needToSearchDirectDiscount() -> Bool {
        return isDiscountEnabled() && checkoutPreference != nil && !directDiscountSearched && paymentData.discount == nil && paymentResult == nil && !paymentData.isComplete() && (paymentMethodPlugins.isEmpty && paymentPlugin == nil)
    }

    private func needValidatePreference() -> Bool {
        return !shouldLoadPreference && !preferenceValidated
    }

    private func needToInitPaymentMethodPlugins() -> Bool {
        if paymentMethodPlugins.isEmpty {
            return false
        }
        return needPaymentMethodPluginInit
    }

    private func needSearch() -> Bool {
        return paymentMethodSearch == nil
    }

    private func isDiscountEnabled() -> Bool {
        return MercadoPagoCheckoutViewModel.flowPreference.isDiscountEnable()
    }
}
