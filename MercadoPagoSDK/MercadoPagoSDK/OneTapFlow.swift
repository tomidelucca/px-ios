//
//  OneTapFlow.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 09/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
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
        #if DEBUG
            print("DEINIT FLOW - \(self)")
        #endif
    }

    func start() {
        executeNextStep()
    }

    func executeNextStep() {
        switch self.viewModel.nextStep() {
        case .SCREEN_REVIEW_AND_CONFIRM_ONE_TAP:
            self.showReviewAndConfirmScreenForOneTap()
        case .SCREEN_SECURITY_CODE:
            self.showSecurityCodeScreen()
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
            // Check if can autoselect plugin
            let paymentMethodPluginsFound = paymentMethodPlugins.filter { (paymentMethodPlugin: PXPaymentMethodPlugin) -> Bool in
                return paymentMethodPlugin.getId() == search.checkoutExpressOption
            }
            if !paymentMethodPluginsFound.isEmpty {
                selectedPaymentOption = paymentMethodPluginsFound[0]
            } else {
                // Check if can autoselect customer card
                let customOptionsFound = search.customerPaymentMethods!.filter { (cardInformation: CardInformation) -> Bool in
                    return cardInformation.getCardId() == search.checkoutExpressOption
                }
                if !customOptionsFound.isEmpty, let customerPaymentOption = customOptionsFound[0] as? PaymentMethodOption {
                    // Checkea que el campo de cuotas no venga vacio para credito y debito. Ver si con debito tiene sentido
                    if customerPaymentOption.isCard() {
                        if !Array.isNullOrEmpty(search.defaultInstallments) {
                            selectedPaymentOption = customerPaymentOption
                        }
                    }
                }}
        }
        return selectedPaymentOption
    }
}
