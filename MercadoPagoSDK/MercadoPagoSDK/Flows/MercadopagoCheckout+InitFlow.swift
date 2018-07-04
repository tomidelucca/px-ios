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
            lifecycleProtocol?.lazyInitFailure(errorDetail: ("Error - \(flowError.errorStep.rawValue)"))
            if let showLazyErrors = lifecycleProtocol?.shouldShowLazyInitErrors?(), showLazyErrors {
                PXComponentFactory.SnackBar.showShortDurationMessage(message: "Error - \(flowError.errorStep.rawValue)")
            }
        } else {
            let customError = MPSDKError(message: "Error", errorDetail: flowError.errorStep.rawValue, retry: flowError.shouldRetry)
            viewModel.errorInputs(error: customError, errorCallback: {
                if flowError.shouldRetry {
                    if self.initMode == .normal {
                        self.pxNavigationHandler.presentLoading()
                    }
                    self.viewModel.initFlow?.setFlowRetry(step: flowError.errorStep)
                    self.executeNextStep()
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
}
