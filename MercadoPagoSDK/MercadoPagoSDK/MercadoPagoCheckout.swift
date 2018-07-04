//
//  MercadoPagoCheckout.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/23/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoPXTracking
import MercadoPagoServices

@objc
public protocol PXCheckoutLifecycleProtocol: NSObjectProtocol {
    func lazyInitDidFinish()
    func lazyInitFailure(errorDetail: String)
    @objc optional func shouldShowLazyInitErrors() -> Bool
}

@objcMembers
open class MercadoPagoCheckout: NSObject {

    private enum InitMode {
        case normal
        case lazy
    }
    private var initMode: InitMode = .normal
    private var lifecycleProtocol: PXCheckoutLifecycleProtocol?

    static var currentCheckout: MercadoPagoCheckout?
    var viewModel: MercadoPagoCheckoutViewModel
    var pxNavigationHandler: PXNavigationHandler

    public init(publicKey: String, accessToken: String, checkoutPreference: CheckoutPreference, paymentData: PaymentData?, paymentResult: PaymentResult?, navigationController: UINavigationController) {

        MercadoPagoCheckoutViewModel.flowPreference.removeHooks()

        MercadoPagoContext.setPublicKey(publicKey)
        MercadoPagoContext.setPayerAccessToken(accessToken)

        ThemeManager.shared.initialize()

        viewModel = MercadoPagoCheckoutViewModel(checkoutPreference: checkoutPreference, paymentData: paymentData, paymentResult: paymentResult)

        ThemeManager.shared.saveNavBarStyleFor(navigationController: navigationController)

        pxNavigationHandler = PXNavigationHandler(navigationController: navigationController)

        MercadoPagoCheckoutViewModel.flowPreference.disableESC()
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
        commondInit()
        if initMode == .lazy {
            if viewModel.initFlow?.getStatus() == .finished {
                executeNextStep()
            } else {
                if viewModel.initFlow?.getStatus() == .running {
                    return
                } else {
                    // Lazy with "ready" to run.
                    pxNavigationHandler.presentInitLoading()
                    executeNextStep()
                }
            }
        } else {
            pxNavigationHandler.presentInitLoading()
            executeNextStep()
        }
    }

    public func lazyStart(lifecycleDelegate: PXCheckoutLifecycleProtocol) {
        viewModel.initFlow?.shouldRestart()
        lifecycleProtocol = lifecycleDelegate
        initMode = .lazy
        commondInit()
        executeNextStep()
    }

    private func commondInit() {
        viewModel.setInitFlowProtocol(flowInitProtocol: self)
        if !shouldApplyDiscount() {
            viewModel.clearDiscount()
        }
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
        self.pxNavigationHandler.navigationController.popViewController(animated: animated)
    }

    private func initialize() {
        initMercadPagoPXTracking()
        MercadoPagoCheckout.currentCheckout = self
        pxNavigationHandler.suscribeToNavigationFlow()
        if let currentCheckout = MercadoPagoCheckout.currentCheckout {
            PXNotificationManager.SuscribeTo.attemptToClose(currentCheckout, selector: #selector(closeCheckout))
        }
        print("p - initialize - startInitFlow")
        viewModel.startInitFlow()
    }

    func executeNextStep() {
        switch self.viewModel.nextStep() {
        case .START :
            print("p - START")
            self.initialize()
        case .SCREEN_PAYMENT_METHOD_SELECTION:
            print("p - SCREEN_PAYMENT_METHOD_SELECTION")
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
        case .FLOW_ONE_TAP:
            self.startOneTapFlow()
        default: break
        }
    }

    private func executePaymentDataCallback() {
        if MercadoPagoCheckoutViewModel.paymentDataCallback != nil {
            MercadoPagoCheckoutViewModel.paymentDataCallback!(self.viewModel.paymentData)
        }
    }

    func finish() {
        pxNavigationHandler.removeRootLoading()

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
        pxNavigationHandler.goToRootViewController()
    }

    func cancel() {
        if let callback = viewModel.callbackCancel {
            callback()
            return
        }
        pxNavigationHandler.goToRootViewController()
    }
    @objc func closeCheckout() {
        PXNotificationManager.UnsuscribeTo.attemptToClose(self)
        cancel()
    }

    public func popToWhenFinish(viewController: UIViewController) {
        pxNavigationHandler.popToWhenFinish(viewController: viewController)
    }

    public func setDiscount(_ discount: PXDiscount, withCampaign campaign: PXCampaign) {
        viewModel.setDiscount(discount, withCampaign: campaign)
    }

    private func shouldApplyDiscount() -> Bool {
        if MercadoPagoCheckoutViewModel.flowPreference.isDiscountEnable(), viewModel.paymentPlugin != nil {
            return true
        }
        return false
    }
}

// MARK: Init flow Protocol
extension MercadoPagoCheckout: InitFlowProtocol {

    func didFailInitFlow(flowError: InitFlowError) {
        if initMode == .lazy {
            lifecycleProtocol?.lazyInitFailure(errorDetail: ("Error - \(flowError.errorStep.rawValue)"))
            if let showLazyErrors = lifecycleProtocol?.shouldShowLazyInitErrors?(), showLazyErrors {
                PXComponentFactory.SnackBar.showShortDurationMessage(message: "Error - \(flowError.errorStep.rawValue)")
            }
        } else {
            let customError = MPSDKError(message: "Error", errorDetail: flowError.errorStep.rawValue, retry: flowError.shouldRetry)
            viewModel.errorInputs(error: customError, errorCallback: {
                if flowError.shouldRetry {
                    self.viewModel.initFlow?.shouldRetry(step: flowError.errorStep)
                }
            })
            executeNextStep()
        }
    }

    func didFinishInitFlow() {
        if initMode == .lazy {
            lifecycleProtocol?.lazyInitDidFinish()
        } else {
            executeNextStep()
        }
    }

    func shouldRetry() {
        executeNextStep()
        viewModel.initFlow?.disposePendingRetry()
    }
}
