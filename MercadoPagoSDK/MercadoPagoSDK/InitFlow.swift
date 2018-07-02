//
//  InitFlow.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 26/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

typealias InitFlowProperties = (paymentData: PaymentData, checkoutPreference: CheckoutPreference, paymentResult: PaymentResult?, paymentPlugin: PXPaymentPluginComponent?, paymentMethodPlugins: [PXPaymentMethodPlugin], paymentMethodSearchResult: PaymentMethodSearch?, loadPreferenceStatus: Bool, directDiscountSearchStatus: Bool)

internal protocol InitFlowProtocol: NSObjectProtocol {
    func didFinishInitFlow()
}

final class InitFlow: PXFlow {
    let pxNavigationHandler: PXNavigationHandler
    let model: InitFlowModel

    private var status: PXFlowStatus = .ready
    private let finishInitCallback: (() -> Void)
    private let errorInitCallback: (() -> Void)

    init(navigationController: PXNavigationHandler, flowProperties: InitFlowProperties, finishCallback: @escaping (() -> Void), errorCallback: @escaping (() -> Void)) {
        pxNavigationHandler = navigationController
        finishInitCallback = finishCallback
        errorInitCallback = errorCallback
        model = InitFlowModel(flowProperties: flowProperties)
    }

    deinit {
        #if DEBUG
            print("DEINIT FLOW - \(self)")
        #endif
    }

    func start() {
        status = .running
        executeNextStep()
    }

    func executeNextStep() {
        switch model.nextStep() {
        case .SERVICE_GET_PREFERENCE:
            getCheckoutPreference()
        case .ACTION_VALIDATE_PREFERENCE:
            validatePreference()
        case .SERVICE_GET_DIRECT_DISCOUNT:
            getDirectDiscount()
        case .SERVICE_GET_PAYMENT_METHODS:
            getPaymentMethodSearch()
        case .SERVICE_PAYMENT_METHOD_PLUGIN_INIT:
            initPaymentMethodPlugins()
        case .FINISH:
            finishFlow()
        case .ERROR: break
            //
        }
    }

    func finishFlow() {
        status = .finished
        finishInitCallback()
    }

    func cancelFlow() {}
    func exitCheckout() {}
}

extension InitFlow {
    func getStatus() -> PXFlowStatus {
        return status
    }
}
