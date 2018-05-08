//
//  MercadoPagoCheckout.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/23/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoPXTracking

@objcMembers
open class MercadoPagoCheckout: NSObject {

    static var currentCheckout: MercadoPagoCheckout?
    var viewModel: MercadoPagoCheckoutViewModel
    var pxNavigationController: PXNavigationController

    public init(publicKey: String, accessToken: String, checkoutPreference: CheckoutPreference, paymentData: PaymentData?, paymentResult: PaymentResult?, discount: DiscountCoupon? = nil, navigationController: UINavigationController) {

        MercadoPagoCheckoutViewModel.flowPreference.removeHooks()

        MercadoPagoContext.setPublicKey(publicKey)
        MercadoPagoContext.setPayerAccessToken(accessToken)

        ThemeManager.shared.initialize()

        viewModel = MercadoPagoCheckoutViewModel(checkoutPreference: checkoutPreference, paymentData: paymentData, paymentResult: paymentResult, discount: discount)

        ThemeManager.shared.saveNavBarStyleFor(navigationController: navigationController)

        MercadoPagoCheckoutViewModel.flowPreference.disableESC()

        pxNavigationController = PXNavigationController(navigationController: navigationController)
    }

    public func setTheme(_ theme: PXTheme) {
        ThemeManager.shared.setTheme(theme: theme)
    }

    public func setDefaultColor(_ color: UIColor) {
        ThemeManager.shared.setDefaultColor(color: color)
    }

    func initMercadPagoPXTracking() {
        MPXTracker.setPublicKey(MercadoPagoContext.sharedInstance.publicKey())
        MPXTracker.setSdkVersion(MercadoPagoContext.sharedInstance.sdkVersion())
        MPXTracker.sharedInstance.startNewFlow()
    }

    public func setBinaryMode(_ binaryMode: Bool) {
        self.viewModel.binaryMode = binaryMode
    }

    public func start() {
        pxNavigationController.presentInitLoading()
        MercadoPagoCheckout.currentCheckout = self
        executeNextStep()
    }

    public func setPaymentResult(paymentResult: PaymentResult) {
        self.viewModel.paymentResult = paymentResult
    }

    public func setCheckoutPreference(checkoutPreference: CheckoutPreference) {
        self.viewModel.checkoutPreference = checkoutPreference
    }

    public func setPaymentData(paymentData: PaymentData) {
        self.viewModel.paymentData = paymentData
    }

    public func setPaymentMethodPlugins(plugins: [PXPaymentMethodPlugin]) {
        self.viewModel.paymentMethodPlugins = plugins
        self.viewModel.paymentMethodPluginsToShow = plugins
    }

    public func getPXCheckoutStore() -> PXCheckoutStore {
        _ = self.viewModel.copyViewModelAndAssignToCheckoutStore()
        return PXCheckoutStore.sharedInstance
    }

    public func setPaymentPlugin(paymentPlugin: PXPaymentPluginComponent) {
        self.viewModel.paymentPlugin = paymentPlugin
    }

    public func resume() {
        MercadoPagoCheckout.currentCheckout = self
        executeNextStep()
    }

    func executePreviousStep(animated: Bool = true) {
        self.pxNavigationController.navigationController.popViewController(animated: animated)
    }

    func initialize() {
        initMercadPagoPXTracking()
        // Disable init:trackScreen for v4.0
        // TODO-v4.1: Change trackScreen by trackEvent, in order to get convertion insights
        // MPXTracker.trackScreen(screenId: TrackingUtil.SCREEN_ID_CHECKOUT, screenName: TrackingUtil.SCREEN_NAME_CHECKOUT)
        executeNextStep()
        pxNavigationController.suscribeToNavigationFlow()
        PXNotificationManager.SuscribeTo.attemptToClose(MercadoPagoCheckout.currentCheckout, selector: #selector(closeCheckout))
    }

    func executeNextStep() {

        switch self.viewModel.nextStep() {
        case .START :
            self.initialize()
        case .SERVICE_GET_PREFERENCE:
            self.getCheckoutPreference()
        case .ACTION_VALIDATE_PREFERENCE:
            self.validatePreference()
        case .SERVICE_GET_DIRECT_DISCOUNT:
            self.getDirectDiscount()
        case .SERVICE_GET_PAYMENT_METHODS:
            self.getPaymentMethodSearch()
        case .SCREEN_PAYMENT_METHOD_SELECTION:
            self.showPaymentMethodsScreen()
        case .SCREEN_CARD_FORM:
            self.showCardForm()
        case .SCREEN_IDENTIFICATION:
            self.showIdentificationScreen()
        case .SCREEN_PAYER_INFO_FLOW:
            self.showPayerInfoFlow()
        case .SCREEN_ENTITY_TYPE:
            self.showEntityTypesScreen()
        case .SCREEN_FINANCIAL_INSTITUTIONS:
            self.showFinancialInstitutionsScreen()
        case .SERVICE_GET_ISSUERS:
            self.getIssuers()
        case .SCREEN_ISSUERS:
            self.showIssuersScreen()
        case .SERVICE_CREATE_CARD_TOKEN:
            self.createCardToken()
        case .SERVICE_GET_IDENTIFICATION_TYPES:
            self.getIdentificationTypes()
        case .SERVICE_GET_PAYER_COSTS:
            self.getPayerCosts()
        case .SCREEN_PAYER_COST:
            self.showPayerCostScreen()
        case .SCREEN_REVIEW_AND_CONFIRM:
            self.showReviewAndConfirmScreen()
        case .SCREEN_REVIEW_AND_CONFIRM_ONE_TAP:
            self.showReviewAndConfirmScreenForOneTap()
        case .SCREEN_SECURITY_CODE:
            self.showSecurityCodeScreen()
        case .SERVICE_POST_PAYMENT:
            self.createPayment()
        case .SERVICE_GET_INSTRUCTIONS:
            self.getInstructions()
        case .SCREEN_PAYMENT_RESULT:
            self.showPaymentResultScreen()
        case .ACTION_FINISH:
            self.finish()
        case .SCREEN_ERROR:
            self.showErrorScreen()
        case .SCREEN_HOOK_BEFORE_PAYMENT_METHOD_CONFIG:
            self.showHookScreen(hookStep: .BEFORE_PAYMENT_METHOD_CONFIG)
        case .SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG:
            self.showHookScreen(hookStep: .AFTER_PAYMENT_METHOD_CONFIG)
        case .SCREEN_HOOK_BEFORE_PAYMENT:
            self.showHookScreen(hookStep: .BEFORE_PAYMENT)
        case .SCREEN_PAYMENT_METHOD_PLUGIN_PAYMENT:
            self.showPaymentMethodPluginPaymentScreen()
        case .SCREEN_PAYMENT_METHOD_PLUGIN_CONFIG:
            self.showPaymentMethodPluginConfigScreen()
        case .SCREEN_PAYMENT_PLUGIN_PAYMENT: //PROCESADORA
            self.showPaymentPluginScreen()
        case .SERVICE_PAYMENT_METHOD_PLUGIN_INIT:
            self.initPaymentMethodPlugins()
        case .FLOW_ONE_TAP:
            self.startOneTapFlow()
        default: break
        }
    }

    func validatePreference() {
        let errorMessage = self.viewModel.checkoutPreference.validate()
        if errorMessage != nil {
            self.viewModel.errorInputs(error: MPSDKError(message: "Hubo un error".localized, errorDetail: errorMessage!, retry: false), errorCallback: { () -> Void in })
        }
        self.executeNextStep()
    }

    private func executePaymentDataCallback() {
        if MercadoPagoCheckoutViewModel.paymentDataCallback != nil {
            MercadoPagoCheckoutViewModel.paymentDataCallback!(self.viewModel.paymentData)
        }
    }

    func finish() {
        pxNavigationController.removeRootLoading()

        if self.viewModel.paymentData.isComplete() && !MercadoPagoCheckoutViewModel.flowPreference.isReviewAndConfirmScreenEnable() && MercadoPagoCheckoutViewModel.paymentDataCallback != nil && !self.viewModel.isCheckoutComplete() {
            MercadoPagoCheckoutViewModel.paymentDataCallback!(self.viewModel.paymentData)
            return

        } else if self.viewModel.paymentData.isComplete() && MercadoPagoCheckoutViewModel.flowPreference.isReviewAndConfirmScreenEnable() && MercadoPagoCheckoutViewModel.paymentDataConfirmCallback != nil && !self.viewModel.isCheckoutComplete() {
            MercadoPagoCheckoutViewModel.paymentDataConfirmCallback!(self.viewModel.paymentData)
            return

        } else if let payment = self.viewModel.payment, let paymentCallback = MercadoPagoCheckoutViewModel.paymentCallback {
            paymentCallback(payment)
            return

        } else if let finishFlowCallback = MercadoPagoCheckoutViewModel.finishFlowCallback {
            finishFlowCallback(self.viewModel.payment)
            return
        }
        pxNavigationController.goToRootViewController()
    }

    func cancel() {
        if let callback = viewModel.callbackCancel {
            callback()
            return
        }
        pxNavigationController.goToRootViewController()
    }
    @objc func closeCheckout() {
        PXNotificationManager.UnsuscribeTo.attemptToClose(self)
        cancel()
    }
}

class OneTapFlow: NSObject {
    let viewModel: OneTapFlowViewModel
    let pxNavigationController: PXNavigationController
    let finishCallback: ((PaymentData) -> Void)
    let cancelCallback: (() -> Void)
    let exitCallback: (() -> Void)

    init(navigationController: PXNavigationController, paymentData: PaymentData, checkoutPreference: CheckoutPreference, search: PaymentMethodSearch, paymentOptionSelected: PaymentMethodOption, finish: @escaping ((PaymentData) -> Void), cancel: @escaping (() -> Void), exit: @escaping (() -> Void)) {
        pxNavigationController = navigationController
        finishCallback = finish
        cancelCallback = cancel
        exitCallback = exit
        viewModel = OneTapFlowViewModel(paymentData: paymentData, checkoutPreference: checkoutPreference, search: search, paymentOptionSelected: paymentOptionSelected)
    }
    deinit {
        print("deinit")
    }

    func start() {
        executeNextStep()
    }

    func executeNextStep() {
        switch self.viewModel.nextStep() {
        case .SCREEN_REVIEW_AND_CONFIRM_ONE_TAP:
            self.showReviewAndConfirmScreenForOneTap()
        case .SCREEN_PAYER_COST:
            self.showPayerCostScreen()
        case .SCREEN_SECURITY_CODE:
            self.showSecurityCodeScreen()
        case .SERVICE_GET_PAYER_COSTS:
            self.getPayerCosts()
        case .ACTION_FINISH:
            self.finish()
        }
    }

    // Cancelar one tap - Cambiar medio de pago
    func cancel() {
        cancelCallback()
    }

    // Finalizar el flujo de one tap - Seguir con el checkout
    func finish() {
        finishCallback(viewModel.paymentData)
    }

    // Salir del flujo - Desde una pantalla de error, etc.
    func exit() {
        exitCallback()
    }
}

extension OneTapFlow {
    static func autoSelectOneTapOption(search: PaymentMethodSearch, paymentMethodPlugins: [PXPaymentMethodPlugin]) -> PaymentMethodOption? {
        var selectedPaymentOption: PaymentMethodOption?
        if search.hasCheckoutDefaultOption() {
            let paymentMethodPluginsFound = paymentMethodPlugins.filter { (paymentMethodPlugin: PXPaymentMethodPlugin) -> Bool in
                return paymentMethodPlugin.getId() == search.checkoutExpressOption
            }
            if !paymentMethodPluginsFound.isEmpty {
                selectedPaymentOption = paymentMethodPluginsFound[0]
            } else {
                let customOptionsFound = search.customerPaymentMethods!.filter { (cardInformation: CardInformation) -> Bool in
                    return cardInformation.getCardId() == search.checkoutExpressOption
                }
                if !customOptionsFound.isEmpty, let customerPaymentOption = customOptionsFound[0] as? PaymentMethodOption {
                    selectedPaymentOption = customerPaymentOption
                }}
        }
        return selectedPaymentOption
    }
}
