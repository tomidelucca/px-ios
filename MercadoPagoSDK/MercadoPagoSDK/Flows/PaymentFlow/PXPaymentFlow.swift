//
//  PaymentFlow.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 26/06/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

internal final class PXPaymentFlow: NSObject, PXFlow {

    var paymentData: PaymentData?
    var checkoutPreference: CheckoutPreference?
    let binaryMode: Bool
    let paymentPlugin: PXPaymentPluginComponent?
    let paymentMethodPaymentPlugin: PXPaymentPluginComponent?
    let mercadoPagoServicesAdapter: MercadoPagoServicesAdapter

    weak var resultHandler: PXPaymentResultHandlerProtocol?
    weak var paymentErrorHandler: PXPaymentErrorHandlerProtocol?

    var paymentResult: PaymentResult?
    var instructionsInfo: InstructionsInfo?
    var businessResult: PXBusinessResult?

    init(paymentPlugin: PXPaymentPluginComponent?, paymentMethodPaymentPlugin: PXPaymentPluginComponent?, binaryMode: Bool, mercadoPagoServicesAdapter: MercadoPagoServicesAdapter, paymentErrorHandler: PXPaymentErrorHandlerProtocol) {
        self.paymentPlugin = paymentPlugin
        self.paymentMethodPaymentPlugin = paymentMethodPaymentPlugin
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
        switch self.nextStep() {
        case .createDefaultPayment:
            createPayment()
        case .createPaymentMethodPaymentPlugin:
            createPaymentWithPlugin(plugin: paymentMethodPaymentPlugin)
        case .createPaymentPlugin:
            createPaymentWithPlugin(plugin: paymentPlugin)
        case .getInstructions:
            getInstructions()
        case .finish:
            finishFlow()
        }
    }

    enum Steps: String {
        case createPaymentPlugin
        case createPaymentMethodPaymentPlugin
        case createDefaultPayment
        case getInstructions
        case finish
    }

    func nextStep() -> Steps {
        if needToCreatePaymentForPaymentPlugin() {
            return .createPaymentPlugin
        } else if needToCreatePaymentForPaymentMethodPaymentPlugin() {
            return .createPaymentMethodPaymentPlugin
        } else if needToCreatePayment() {
            return .createDefaultPayment
        } else if needToGetInstructions() {
            return .getInstructions
        } else {
            return .finish
        }
    }

    func needToCreatePaymentForPaymentPlugin() -> Bool {
        if paymentPlugin == nil {
            return false
        }

        if !needToCreatePayment() {
            return false
        }

        assignToCheckoutStore()
        if let shouldSkip = paymentPlugin?.support?(pluginStore: PXCheckoutStore.sharedInstance), !shouldSkip {
            return false
        }
        return true
    }

    func needToCreatePaymentForPaymentMethodPaymentPlugin() -> Bool {
        if paymentMethodPaymentPlugin == nil {
            return false
        }

        if !needToCreatePayment() {
            return false
        }

        assignToCheckoutStore()
        return self.paymentData?.paymentMethod?.paymentTypeId == PaymentTypeId.PAYMENT_METHOD_PLUGIN.rawValue
    }

    func needToCreatePayment() -> Bool {
        return paymentResult == nil && businessResult == nil
    }

    func needToGetInstructions() -> Bool {
        guard let paymentResult = self.paymentResult else {
            return false
        }

        guard !String.isNullOrEmpty(paymentResult.paymentId) else {
            return false
        }

        return isOfflinePayment() && instructionsInfo == nil
    }

    func isOfflinePayment() -> Bool {
        guard let paymentTypeId = paymentData?.paymentMethod?.paymentTypeId else {
            return false
        }
        return !PaymentTypeId.isOnlineType(paymentTypeId: paymentTypeId)
    }

    func createPaymentWithPlugin(plugin: PXPaymentPluginComponent?) {
        guard let paymentData = paymentData, let plugin = plugin else {
            return
        }

        paymentPlugin?.didReceive?(pluginStore: PXCheckoutStore.sharedInstance)

        if let createPayment = plugin.createPayment {
            let paymentPluginResult = createPayment(PXCheckoutStore.sharedInstance, self as PXPaymentFlowHandlerProtocol)

            if paymentPluginResult.statusDetail == RejectedStatusDetail.INVALID_ESC {
                paymentErrorHandler?.escError()
                return
            }

            let paymentResult = PaymentResult(status: paymentPluginResult.status, statusDetail: paymentPluginResult.statusDetail, paymentData: paymentData, payerEmail: nil, paymentId: paymentPluginResult.receiptId, statementDescription: nil)
            self.paymentResult = paymentResult
            self.executeNextStep()
        } else if let createPaymentForBussinessResult = plugin.createPaymentWithBusinessResult {
            let businessResult = createPaymentForBussinessResult(PXCheckoutStore.sharedInstance, self as PXPaymentFlowHandlerProtocol)
            self.businessResult = businessResult
            self.executeNextStep()
        } else {
            self.showErrorScreen(message: "Hubo un error".localized, errorDetails: "", retry: false)
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
                return
            }
            let paymentResult = PaymentResult(payment: payment, paymentData: paymentData)
            self.paymentResult = paymentResult
            self.executeNextStep()

            }, failure: { [weak self] (error) in

                let mpError = MPSDKError.convertFrom(error, requestOrigin: ApiUtil.RequestOrigin.CREATE_PAYMENT.rawValue)

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

    func assignToCheckoutStore() {
        if let paymentData = paymentData {
            PXCheckoutStore.sharedInstance.paymentData = paymentData
        }
        PXCheckoutStore.sharedInstance.checkoutPreference = checkoutPreference
    }

    static func readyForPayment(paymentData: PaymentData) -> Bool {
        return paymentData.isComplete()
    }

    func getPaymentTimeOut() -> TimeInterval {
        let instructionTimeOut: TimeInterval = isOfflinePayment() ? 15 : 0
        if let paymentPluginTimeOut = paymentPlugin?.paymentTimeOut?() {
            return paymentPluginTimeOut + instructionTimeOut
        } else if let paymentMethodPluginTimeOut = paymentMethodPaymentPlugin?.paymentTimeOut?() {
            return paymentMethodPluginTimeOut + instructionTimeOut
        } else {
            return mercadoPagoServicesAdapter.getTimeOut() + instructionTimeOut
        }
    }

    func getInstructions() {

        guard let paymentResult = paymentResult else {
            fatalError("Get Instructions - Payment Result does no exist")
        }

        guard let paymentId = paymentResult.paymentId else {
            fatalError("Get Instructions - Payment Id does no exist")
        }

        guard let paymentTypeId = paymentResult.paymentData?.getPaymentMethod()?.paymentTypeId else {
            fatalError("Get Instructions - Payment Method Type Id does no exist")
        }

        mercadoPagoServicesAdapter.getInstructions(paymentId: paymentId, paymentTypeId: paymentTypeId, callback: { [weak self] (instructionsInfo) in
            self?.instructionsInfo = instructionsInfo
            self?.executeNextStep()

            }, failure: {[weak self] (error) in

                let mpError = MPSDKError.convertFrom(error, requestOrigin: ApiUtil.RequestOrigin.GET_INSTRUCTIONS.rawValue)
                self?.showErrorScreen(error: mpError)

        })
    }

    func cancelFlow() {}

    func finishFlow() {
        if let paymentResult = paymentResult {
            self.resultHandler?.finishPaymentFlow(paymentResult: (paymentResult), instructionsInfo: instructionsInfo)
        } else if let businessResult = businessResult {
            self.resultHandler?.finishPaymentFlow(businessResult: businessResult)
        }
    }

    func exitCheckout() {}

}

extension PXPaymentFlow: PXPaymentFlowHandlerProtocol {
    public func showErrorScreen(message: String, errorDetails: String, retry: Bool = true) {
        let error = MPSDKError(message: message, errorDetail: errorDetails, retry: retry)
        resultHandler?.finishPaymentFlow(error: error)
    }

    func showErrorScreen(error: MPSDKError) {
        resultHandler?.finishPaymentFlow(error: error)
    }
}
