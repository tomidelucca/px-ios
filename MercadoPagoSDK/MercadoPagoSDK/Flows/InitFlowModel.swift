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
    let paymentPlugin: PXPaymentPluginComponent?
    let paymentMethodPlugins: [PXPaymentMethodPlugin]
    var paymentMethodPluginsToShow = [PXPaymentMethodPlugin]()

    var checkoutPreference: CheckoutPreference
    var paymentData: PaymentData

    private var paymentMethodSearch: PaymentMethodSearch?
    private var paymentMethodOptions: [PaymentMethodOption]?
    private var paymentOptionSelected: PaymentMethodOption?
    private var availablePaymentMethods: [PaymentMethod]?
    private var rootPaymentMethodOptions: [PaymentMethodOption]?
    private var customPaymentOptions: [CardInformation]?

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

    func updateCheckoutModel(paymentMethodsResponse: PaymentMethodSearch) {

        self.paymentMethodSearch = paymentMethodsResponse

        guard let paymentMethodSearch = self.paymentMethodSearch else {
            return
        }

        self.rootPaymentMethodOptions = paymentMethodSearch.groups
        self.paymentMethodOptions = self.rootPaymentMethodOptions
        self.availablePaymentMethods = paymentMethodSearch.paymentMethods

        if !Array.isNullOrEmpty(paymentMethodSearch.customerPaymentMethods) {
            if !MercadoPagoContext.accountMoneyAvailable() {
                self.customPaymentOptions =  paymentMethodSearch.customerPaymentMethods!.filter({ (element: CardInformation) -> Bool in
                    return element.getPaymentMethodId() != PaymentTypeId.ACCOUNT_MONEY.rawValue
                })
            } else {
                self.customPaymentOptions = paymentMethodSearch.customerPaymentMethods
            }
        }

        let totalPaymentMethodSearchCount = paymentMethodSearch.getPaymentOptionsCount()
        self.paymentMethodPluginsToShow = getPluginPaymentMethodToShow()
        let totalPaymentMethodsToShow =  totalPaymentMethodSearchCount + paymentMethodPluginsToShow.count

        if totalPaymentMethodsToShow == 0 {
            self.setErrorInputs(error: MPSDKError(message: "Hubo un error".localized, errorDetail: "No se ha podido obtener los métodos de pago con esta preferencia".localized, retry: false), errorCallback: { () in
            })
        } else if totalPaymentMethodsToShow == 1 {
            autoselectOnlyPaymentMethod()
        }
    }

    private func getPluginPaymentMethodToShow() -> [PXPaymentMethodPlugin] {
        //_ = copyViewModelAndAssignToCheckoutStore() //TODO-JUAN: Ver el copy asssign.
        return paymentMethodPlugins.filter {$0.mustShowPaymentMethodPlugin(PXCheckoutStore.sharedInstance) == true}
    }

    private func autoselectOnlyPaymentMethod() {

        guard let paymentMethodSearch = self.paymentMethodSearch else {
            return
        }

        if !paymentMethodSearch.paymentMethods.isEmpty, !paymentMethodSearch.paymentMethods[0].isCard {
            // TODO JUAN
            // self.reviewScreenPreference.disableChangeMethodOption()
        }

        if !Array.isNullOrEmpty(paymentMethodSearch.groups) && paymentMethodSearch.groups.count == 1 {
            self.updateCheckoutModel(paymentOptionSelected: paymentMethodSearch.groups[0])
        } else if !Array.isNullOrEmpty(paymentMethodSearch.customerPaymentMethods) && paymentMethodSearch.customerPaymentMethods?.count == 1 {
            guard let customOption = paymentMethodSearch.customerPaymentMethods![0] as? PaymentMethodOption else {
                fatalError("Cannot conver customerPaymentMethod to PaymentMethodOption")
            }
            self.updateCheckoutModel(paymentOptionSelected: customOption)
        } else if  !Array.isNullOrEmpty(paymentMethodPluginsToShow) && paymentMethodPluginsToShow.count == 1 {
            self.updateCheckoutModel(paymentOptionSelected: paymentMethodPluginsToShow[0])
        }
    }
}

// MARK: nextStep - State machine
extension InitFlowModel {
    func nextStep() -> Steps {
        if hasError() {
            return .ERROR
        }

        if needLoadPreference() {
            shouldLoadPreference = false
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
            directDiscountSearched = true
            return .SERVICE_GET_DIRECT_DISCOUNT
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

    private func hasError() -> Bool {
        return MercadoPagoCheckoutViewModel.error != nil
    }
}
