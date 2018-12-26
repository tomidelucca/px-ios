//
//  OneTapFlowViewModel.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 09/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final internal class OneTapFlowModel: PXFlowModel {
    enum Steps: String {
        case finish
        case screenReviewOneTap
        case screenSecurityCode
        case serviceCreateESCCardToken
        case payment
    }

    var paymentData: PXPaymentData
    let checkoutPreference: PXCheckoutPreference
    var paymentOptionSelected: PaymentMethodOption
    let search: PXPaymentMethodSearch
    var readyToPay: Bool = false
    var paymentResult: PaymentResult?
    var instructionsInfo: PXInstructions?
    var businessResult: PXBusinessResult?
    var consumedDiscount: Bool = false
    var customerPaymentOptions: [CustomerPaymentMethod]?
    var paymentMethodPlugins: [PXPaymentMethodPlugin]?

    // Payment flow
    var paymentFlow: PXPaymentFlow?
    weak var paymentResultHandler: PXPaymentResultHandlerProtocol?

    var chargeRules: [PXPaymentTypeChargeRule]?

    // In order to ensure data updated create new instance for every usage
    private var amountHelper: PXAmountHelper {
        get {
            return PXAmountHelper(preference: self.checkoutPreference, paymentData: self.paymentData, chargeRules: chargeRules, consumedDiscount: consumedDiscount, paymentConfigurationService: self.paymentConfigurationService)
        }
    }

    let mpESCManager: MercadoPagoESC
    let advancedConfiguration: PXAdvancedConfiguration
    let mercadoPagoServicesAdapter: MercadoPagoServicesAdapter
    let paymentConfigurationService: PXPaymentConfigurationServices

    init(paymentData: PXPaymentData, checkoutPreference: PXCheckoutPreference, search: PXPaymentMethodSearch, paymentOptionSelected: PaymentMethodOption, chargeRules: [PXPaymentTypeChargeRule]?, consumedDiscount: Bool = false, mercadoPagoServicesAdapter: MercadoPagoServicesAdapter, advancedConfiguration: PXAdvancedConfiguration, paymentConfigurationService: PXPaymentConfigurationServices) {
        self.consumedDiscount = consumedDiscount
        self.paymentData = paymentData.copy() as? PXPaymentData ?? paymentData
        self.checkoutPreference = checkoutPreference
        self.search = search
        self.paymentOptionSelected = paymentOptionSelected
        self.advancedConfiguration = advancedConfiguration
        self.chargeRules = chargeRules
        self.mercadoPagoServicesAdapter = mercadoPagoServicesAdapter
        self.mpESCManager = MercadoPagoESCImplementation(enabled: advancedConfiguration.escEnabled)
        self.paymentConfigurationService = paymentConfigurationService

        // Payer cost pre selection.
        if let firstCardID = search.expressCho?.first?.oneTapCard?.cardId, let payerCost = amountHelper.paymentConfigurationService.getSelectedPayerCostsForPaymentMethod(firstCardID) {
            updateCheckoutModel(payerCost: payerCost)
        }
    }
    public func nextStep() -> Steps {
        if needReviewAndConfirmForOneTap() {
            return .screenReviewOneTap
        }
        if needSecurityCode() {
            return .screenSecurityCode
        }
        if needCreateESCToken() {
            return .serviceCreateESCCardToken
        }
        if needCreatePayment() {
            return .payment
        }
        return .finish
    }
}

// MARK: Create view model
internal extension OneTapFlowModel {
    func savedCardSecurityCodeViewModel() -> SecurityCodeViewModel {
        guard let cardInformation = self.paymentOptionSelected as? PXCardInformation else {
            fatalError("Cannot convert payment option selected to CardInformation")
        }

        guard let paymentMethod = paymentData.paymentMethod else {
            fatalError("Don't have paymentData to open Security View Controller")
        }

        let reason = SecurityCodeViewModel.Reason.SAVED_CARD
        return SecurityCodeViewModel(paymentMethod: paymentMethod, cardInfo: cardInformation, reason: reason)
    }

    func reviewConfirmViewModel() -> PXOneTapViewModel {
        let viewModel = PXOneTapViewModel(amountHelper: self.amountHelper, paymentOptionSelected: paymentOptionSelected, advancedConfig: advancedConfiguration, userLogged: false)
        viewModel.expressData = search.expressCho
        viewModel.paymentMethods = search.paymentMethods
        viewModel.items = checkoutPreference.items
        viewModel.paymentMethodPlugins = paymentMethodPlugins
        return viewModel
    }
}

// MARK: Update view models
internal extension OneTapFlowModel {
    func updateCheckoutModel(paymentData: PXPaymentData) {
        self.paymentData = paymentData
        self.readyToPay = true
    }

    func updateCheckoutModel(token: PXToken) {
        if !token.cardId.isEmpty {
            if let esc = token.esc {
                mpESCManager.saveESC(cardId: token.cardId, esc: esc)
            } else {
                mpESCManager.deleteESC(cardId: token.cardId)
            }
        }

        self.paymentData.updatePaymentDataWith(token: token)
    }

    func updateCheckoutModel(payerCost: PXPayerCost) {
        if paymentOptionSelected.isCard() {
            self.paymentData.updatePaymentDataWith(payerCost: payerCost)
            self.paymentData.cleanToken()
        }
    }
}

// MARK: Flow logic
internal extension OneTapFlowModel {
    func needReviewAndConfirmForOneTap() -> Bool {
        if readyToPay {
            return false
        }

        if paymentData.isComplete(shouldCheckForToken: false) {
            return true
        }

        return false
    }

    func needSecurityCode() -> Bool {
        guard let paymentMethod = self.paymentData.getPaymentMethod() else {
            return false
        }

        if !readyToPay {
            return false
        }

        let hasInstallmentsIfNeeded = paymentData.hasPayerCost() || !paymentMethod.isCreditCard
        let isCustomerCard = paymentOptionSelected.isCustomerPaymentMethod() && paymentOptionSelected.getId() != PXPaymentTypes.ACCOUNT_MONEY.rawValue

        if isCustomerCard && !paymentData.hasToken() && hasInstallmentsIfNeeded && !hasSavedESC() {
            return true
        }
        return false
    }

    func needCreateESCToken() -> Bool {
        guard let paymentMethod = self.paymentData.getPaymentMethod() else {
            return false
        }

        let hasInstallmentsIfNeeded = self.paymentData.getPayerCost() != nil || !paymentMethod.isCreditCard
        let savedCardWithESC = !paymentData.hasToken() && paymentMethod.isCard && hasSavedESC() && hasInstallmentsIfNeeded

        return savedCardWithESC
    }

    func needCreatePayment() -> Bool {
        if !readyToPay {
            return false
        }
        return paymentData.isComplete(shouldCheckForToken: false) && paymentFlow != nil && paymentResult == nil && businessResult == nil
    }

    func hasSavedESC() -> Bool {
        if let card = paymentOptionSelected as? PXCardInformation {
            return mpESCManager.getESC(cardId: card.getCardId()) == nil ? false : true
        }
        return false
    }

    func needToShowLoading() -> Bool {
        guard let paymentMethod = paymentData.getPaymentMethod() else {
            return true
        }
        if let paymentFlow = paymentFlow, paymentMethod.isAccountMoney || hasSavedESC() {
            return paymentFlow.hasPaymentPluginScreen()
        }
        return true
    }

    func getTimeoutForOneTapReviewController() -> TimeInterval {
        if let paymentFlow = paymentFlow {
            paymentFlow.model.paymentData = paymentData
            let tokenTimeOut: TimeInterval = mercadoPagoServicesAdapter.getTimeOut()
            // Payment Flow timeout + tokenization TimeOut
            return paymentFlow.getPaymentTimeOut() + tokenTimeOut
        }
        return 0
    }

}
