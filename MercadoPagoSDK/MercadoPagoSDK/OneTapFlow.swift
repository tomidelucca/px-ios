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
    let pxNavigationHandler: PXNavigationHandler
    let finishOneTapCallback: ((PaymentData) -> Void)
    let cancelOneTapCallback: (() -> Void)
    let exitCheckoutCallback: (() -> Void)

    init(navigationController: PXNavigationHandler, paymentData: PaymentData, checkoutPreference: CheckoutPreference, search: PaymentMethodSearch, paymentOptionSelected: PaymentMethodOption, finishOneTap: @escaping ((PaymentData) -> Void), cancelOneTap: @escaping (() -> Void), exitCheckout: @escaping (() -> Void)) {
        pxNavigationHandler = navigationController
        finishOneTapCallback = finishOneTap
        cancelOneTapCallback = cancelOneTap
        exitCheckoutCallback = exitCheckout
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
        cancelOneTapCallback()
    }

    // Finalizar el flujo de one tap - Seguir con el checkout
    func finish() {
        finishOneTapCallback(viewModel.paymentData)
    }

    // Salir del flujo - Desde una pantalla de error, etc.
    func exit() {
        exitCheckoutCallback()
    }
}

extension OneTapFlow {
    /// Returns a auto selected payment option from a paymentMethodSearch object. If no option can be selected it returns nil
    ///
    /// - Parameters:
    ///   - search: payment method search item
    ///   - paymentMethodPlugins: payment Methods plugins that can be show
    /// - Returns: selected payment option if possible
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
                    // Checks if card has installments
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
