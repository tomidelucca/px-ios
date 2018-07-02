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
    func didFailInitFlow()
}

final class InitFlow: PXFlow {
    let pxNavigationHandler: PXNavigationHandler
    let model: InitFlowModel

    private var status: PXFlowStatus = .ready
    private let finishInitCallback: (() -> Void)
    private let errorInitCallback: (() -> Void)

    init(navigationHandler: PXNavigationHandler, flowProperties: InitFlowProperties, finishCallback: @escaping (() -> Void), errorCallback: @escaping (() -> Void)) {
        pxNavigationHandler = navigationHandler
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
        if status != .running {
            status = .running
            executeNextStep()
        }
    }

    func executeNextStep() {
        switch model.nextStep() {
        case .SERVICE_GET_PREFERENCE:
            print("p - SERVICE_GET_PREFERENCE")
            getCheckoutPreference()
        case .ACTION_VALIDATE_PREFERENCE:
            print("p - ACTION_VALIDATE_PREFERENCE")
            validatePreference()
        case .SERVICE_GET_DIRECT_DISCOUNT:
            print("p - SERVICE_GET_DIRECT_DISCOUNT")
            getDirectDiscount()
        case .SERVICE_GET_PAYMENT_METHODS:
            print("p - SERVICE_GET_PAYMENT_METHODS")
            getPaymentMethodSearch()
        case .SERVICE_PAYMENT_METHOD_PLUGIN_INIT:
            print("p - SERVICE_PAYMENT_METHOD_PLUGIN_INIT")
            initPaymentMethodPlugins()
        case .FINISH:
            print("p - FINISH - INIT FLOW")
            finishFlow()
        case .ERROR:
            print("p - ERROR - INIT FLOW")
            cancelFlow()
        }
    }

    func finishFlow() {
        status = .finished
        finishInitCallback()
    }

    func cancelFlow() {
        status = .finished
        errorInitCallback()
    }

    func exitCheckout() {}
}

// MARK: - Getters
extension InitFlow {
    func getStatus() -> PXFlowStatus {
        return status
    }

    func shouldRestart() {
        if status != .running {
            status = .ready
        }
    }
}
