//
//  InitFlow.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 26/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class InitFlow: PXFlow {
    let pxNavigationHandler: PXNavigationHandler
    let model: InitFlowModel

    private var status: PXFlowStatus = .ready
    private let finishInitCallback: ((PaymentMethodSearch) -> Void)
    private let errorInitCallback: ((InitFlowError) -> Void)

    init(navigationHandler: PXNavigationHandler, flowProperties: InitFlowProperties, finishCallback: @escaping ((PaymentMethodSearch) -> Void), errorCallback: @escaping ((InitFlowError) -> Void)) {
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
        let nextStep = model.nextStep()
        print("Step: \(nextStep.rawValue)")
        switch nextStep {
        case .SERVICE_GET_PREFERENCE:
            getCheckoutPreference()
        case .ACTION_VALIDATE_PREFERENCE:
            validatePreference()
        case .SERVICE_GET_CAMPAIGNS:
            getCampaigns()
        case .SERVICE_GET_DIRECT_DISCOUNT:
            getDirectDiscount()
        case .SERVICE_GET_PAYMENT_METHODS:
            getPaymentMethodSearch()
        case .SERVICE_PAYMENT_METHOD_PLUGIN_INIT:
            initPaymentMethodPlugins()
        case .FINISH:
            finishFlow()
        case .ERROR:
            cancelFlow()
        }
    }

    func finishFlow() {
        status = .finished
        if let paymentMethodsSearch = model.getPaymentMethodSearch() {
            finishInitCallback(paymentMethodsSearch)
        } else {
            cancelFlow()
        }
    }

    func cancelFlow() {
        status = .finished
        errorInitCallback(model.getError())
        model.resetError()
    }

    func exitCheckout() {}
}

// MARK: - Getters
extension InitFlow {
    func setFlowRetry(step: InitFlowModel.Steps) {
        status = .ready
        model.setPendingRetry(forStep: step)
    }

    func disposePendingRetry() {
        model.removePendingRetry()
    }

    func getStatus() -> PXFlowStatus {
        return status
    }

    func restart() {
        if status != .running {
            status = .ready
        }
    }
}
