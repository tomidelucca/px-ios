//
//  PaymentFlow.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 26/06/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

internal final class PXPaymentFlow: NSObject {

    var paymentData: PaymentData?
    var checkoutPreference: CheckoutPreference?
    let binaryMode: Bool
    let paymentPlugin: PXPaymentPluginComponent?
    let paymentMethodPaymentPlugin: PXPaymentPluginComponent?
    let navigationHandler: PXNavigationHandler
    let mercadoPagoServicesAdapter: MercadoPagoServicesAdapter

    weak var resultHandler: PXPaymentResultHandlerProtocol?
    weak var paymentErrorHandler: PXPaymentErrorHandlerProtocol?

    var shouldShowLoading: Bool = true

    init(paymentPlugin: PXPaymentPluginComponent?, paymentMethodPaymentPlugin: PXPaymentPluginComponent?, navigationHandler: PXNavigationHandler, binaryMode: Bool, mercadoPagoServicesAdapter: MercadoPagoServicesAdapter, paymentErrorHandler: PXPaymentErrorHandlerProtocol) {
        self.paymentPlugin = paymentPlugin
        self.paymentMethodPaymentPlugin = paymentMethodPaymentPlugin
        self.navigationHandler = navigationHandler
        self.binaryMode = binaryMode
        self.mercadoPagoServicesAdapter = mercadoPagoServicesAdapter
        self.paymentErrorHandler = paymentErrorHandler
    }

    func setData(paymentData: PaymentData, checkoutPreference: CheckoutPreference, resultHandler: PXPaymentResultHandlerProtocol) {
        self.paymentData = paymentData
        self.checkoutPreference = checkoutPreference
        self.resultHandler = resultHandler
    }

    deinit {
        #if DEBUG
        print("DEINIT FLOW - \(self)")
        #endif
    }

    func start() {
        executeNextStep()
    }

    func executeNextStep() {
        // TODO: Pode hacer pagos con bussiness result
        switch self.nextStep() {
        case .defaultPayment:
            createPayment()
        case .paymentMethodPaymentPlugin:
            createPaymentWithPlugin(plugin: paymentMethodPaymentPlugin)
        case .paymentPlugin:
            createPaymentWithPlugin(plugin: paymentPlugin)
        }
    }

    enum Steps: String {
        case paymentPlugin
        case paymentMethodPaymentPlugin
        case defaultPayment
    }

    func nextStep() -> Steps {
        if needToCreatePaymentForPaymentPlugin() {
            return .paymentPlugin
        } else if needToCreatePaymentForPaymentMethodPaymentPlugin() {
            return .paymentMethodPaymentPlugin
        } else {
            return .defaultPayment
        }
    }

    func needToCreatePaymentForPaymentPlugin() -> Bool {
        if paymentPlugin == nil {
            return false
        }
        _ = copyViewModelAndAssignToCheckoutStore()

        if let shouldSkip = paymentPlugin?.support?(pluginStore: PXCheckoutStore.sharedInstance), !shouldSkip {
            return false
        }

        return true
    }

    func needToCreatePaymentForPaymentMethodPaymentPlugin() -> Bool {
        if paymentMethodPaymentPlugin == nil {
            return false
        }
        _ = copyViewModelAndAssignToCheckoutStore()

        if let shouldSkip = paymentMethodPaymentPlugin?.support?(pluginStore: PXCheckoutStore.sharedInstance), !shouldSkip {
            return false
        }
        return true
    }

    func createPaymentWithPlugin(plugin: PXPaymentPluginComponent?) {
        guard let paymentData = paymentData, let plugin = plugin else {
            return
        }

        if copyViewModelAndAssignToCheckoutStore() {
            paymentPlugin?.didReceive?(pluginStore: PXCheckoutStore.sharedInstance)
        }

        if let createPayment = plugin.createPayment {
            let paymentPluginResult = createPayment(PXCheckoutStore.sharedInstance, self as PXPaymentFlowHandlerProtocol)

            if paymentPluginResult.statusDetail == RejectedStatusDetail.INVALID_ESC {
                paymentErrorHandler?.escError()
                return
            }
            // TODO: Ver esto
            //        if let paymentMethodPlugin = self.checkout?.viewModel.paymentOptionSelected as? PXPaymentMethodPlugin {
            //            paymentData.paymentMethod?.setExternalPaymentMethodImage(externalImage: paymentMethodPlugin.getImage())
            //        }

            let paymentResult = PaymentResult(status: paymentPluginResult.status, statusDetail: paymentPluginResult.statusDetail, paymentData: paymentData, payerEmail: nil, paymentId: paymentPluginResult.receiptId, statementDescription: nil)
            resultHandler?.finishPaymentFlow(paymentResult: paymentResult)
            return
        } else if let createPaymentForBussinessResult = plugin.createPaymentWithBusinessResult {
            let bussinessResult = createPaymentForBussinessResult(PXCheckoutStore.sharedInstance, self as PXPaymentFlowHandlerProtocol)
            resultHandler?.finishPaymentFlow(businessResult: bussinessResult)
            return
        } else {
            self.showErrorScreen(message: "Hubo un error".localized, errorDetails: "", retry: false)
            return
        }
    }

    func createPayment() {
        guard let paymentData = paymentData, let checkoutPreference = checkoutPreference else {
            return
        }

        var paymentBody: [String: Any]
        if MercadoPagoCheckoutViewModel.servicePreference.isUsingDeafaultPaymentSettings() {
            let mpPayment = MercadoPagoCheckoutViewModel.createMPPayment(preferenceId: checkoutPreference.preferenceId, paymentData: paymentData, binaryMode: binaryMode)
            paymentBody = mpPayment.toJSON()
        } else {
            paymentBody = paymentData.toJSON()
        }

        var createPaymentQuery: [String: String]? = [:]
        if let paymentAdditionalInfo = MercadoPagoCheckoutViewModel.servicePreference.getPaymentAddionalInfo() as? [String: String] {
            createPaymentQuery = paymentAdditionalInfo
        } else {
            createPaymentQuery = nil
        }

        mercadoPagoServicesAdapter.createPayment(url: MercadoPagoCheckoutViewModel.servicePreference.getPaymentURL(), uri: MercadoPagoCheckoutViewModel.servicePreference.getPaymentURI(), paymentData: paymentBody as NSDictionary, query: createPaymentQuery, callback: { (payment) in
            guard let paymentData = self.paymentData else {
                // return?
                return
            }
            let paymentResult = PaymentResult(payment: payment, paymentData: paymentData)
            self.resultHandler?.finishPaymentFlow(paymentResult: paymentResult)

            }, failure: { [weak self] (error) in

                let mpError = MPSDKError.convertFrom(error, requestOrigin: ApiUtil.RequestOrigin.CREATE_PAYMENT.rawValue)
                mpError.retry = true

                // ESC error
                if let apiException = mpError.apiException, apiException.containsCause(code: ApiUtil.ErrorCauseCodes.INVALID_PAYMENT_WITH_ESC.rawValue) {
                    self?.paymentErrorHandler?.escError()

                    // Identification number error
                } else if let apiException = mpError.apiException, apiException.containsCause(code: ApiUtil.ErrorCauseCodes.INVALID_PAYMENT_IDENTIFICATION_NUMBER.rawValue) {
                    self?.paymentErrorHandler?.identificationError()

                } else {
                    self?.showErrorScreen(error: mpError)
                }

        })
    }

    func copyViewModelAndAssignToCheckoutStore() -> Bool {
        // Set a copy of CheckoutVM in HookStore
        if let newPaymentData = paymentData?.copy() as? PaymentData {
            PXCheckoutStore.sharedInstance.paymentData = newPaymentData
            // TODO: ver si esto es un problmea
            //PXCheckoutStore.sharedInstance.paymentOptionSelected = mercadoPagoCheckoutViewModel.paymentOptionSelected
        }
        // TODO: Hacer copia de esto
        PXCheckoutStore.sharedInstance.checkoutPreference = checkoutPreference
        return true
    }

    static func readyForPayment(paymentData: PaymentData) -> Bool {
        return paymentData.isComplete()
    }

}

extension PXPaymentFlow: PXPaymentFlowHandlerProtocol {
    public func showErrorScreen(message: String, errorDetails: String, retry: Bool = true) {
        let error = MPSDKError(message: message, errorDetail: errorDetails, retry: retry)
        showErrorScreen(error: error)
    }

    func showErrorScreen(error: MPSDKError) {
        self.navigationHandler.showErrorScreen(error: error, callbackCancel: self.paymentErrorHandler?.exitCheckout, errorCallback: { () in
            self.executeNextStep()
        })
    }
}
