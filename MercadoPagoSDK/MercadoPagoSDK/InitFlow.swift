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
    let viewModel: InitFlowViewModel
    private var status: PXFlowStatus = .ready

    private let finishInitCallback: (() -> Void)
    private let errorInitCallback: (() -> Void)

    init(navigationController: PXNavigationHandler, finishCallback: @escaping (() -> Void), errorCallback: @escaping (() -> Void)) {
        pxNavigationHandler = navigationController
        finishInitCallback = finishCallback
        errorInitCallback = errorCallback
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

    }

    func finishFlow() {
        status = .finished
    }

    func cancelFlow() {}
    func exitCheckout() {}
}

extension InitFlow {
    func getStatus() -> PXFlowStatus {
        return status
    }
}
