//
//  MercadopagoCheckout+InitFlow.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 4/7/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

// MARK: Init flow Protocol
extension MercadoPagoCheckout: InitFlowProtocol {
    func didFailInitFlow(flowError: InitFlowError) {
        if initMode == .lazy {
            initProtocol?.failure(checkout: self)
            trackErrorEvent(flowError: flowError)
            #if DEBUG
                print("Error - \(flowError.errorStep.rawValue)")
            #endif
        } else {
            var errorDetail = ""
            #if DEBUG
                errorDetail = flowError.errorStep.rawValue
            #endif
            let customError = MPSDKError(message: "Error".localized, errorDetail: errorDetail, retry: flowError.shouldRetry, requestOrigin: flowError.requestOrigin?.rawValue)
            viewModel.errorInputs(error: customError, errorCallback: { [weak self] in
                if flowError.shouldRetry {
                    if self?.initMode == .normal {
                        self?.viewModel.pxNavigationHandler.presentLoading()
                    }
                    self?.viewModel.initFlow?.setFlowRetry(step: flowError.errorStep)
                    self?.executeNextStep()
                }
            })
            executeNextStep()
        }
    }

    func didFinishInitFlow() {
        if initMode == .lazy {
            initProtocol?.didFinish(checkout: self)
        } else {
            executeNextStep()
        }
    }
}
extension MercadoPagoCheckout {
    func trackErrorEvent(flowError: InitFlowError) {
        var properties: [String: Any] = [:]
        properties["path"] = TrackingPaths.Screens.PaymentVault.getPaymentVaultPath()
        properties["style"] = "screen"
        properties["id"] = "px_generic_error"
        properties["message"] = "Hubo un error"
        properties["attributable_to"] = "mercadopago"
        var extraDic: [String: Any] = [:]
        extraDic["api_url"] =  flowError.requestOrigin
        extraDic["retry_available"] = flowError.shouldRetry
        if let cause = flowError.apiException?.cause?.first {
            if !String.isNullOrEmpty(cause.code) {
                extraDic["api_status_code"] = cause.code
                extraDic["api_error_message"] = cause.causeDescription
            }
        }
        properties["extra_info"] = extraDic
        MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.getErrorPath(), properties: properties)
    }
}
