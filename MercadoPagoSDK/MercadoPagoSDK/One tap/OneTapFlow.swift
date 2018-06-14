//
//  OneTapFlow.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 09/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
final class OneTapFlow: PXFlow {

    let viewModel: OneTapFlowViewModel
    let pxNavigationHandler: PXNavigationHandler
    let finishOneTapCallback: ((PaymentData) -> Void)
    let cancelOneTapCallback: (() -> Void)
    let exitCheckoutCallback: (() -> Void)

    init(navigationController: PXNavigationHandler, paymentData: PaymentData, checkoutPreference: CheckoutPreference, search: PaymentMethodSearch, paymentOptionSelected: PaymentMethodOption, reviewScreenPreference: ReviewScreenPreference, finishOneTap: @escaping ((PaymentData) -> Void), cancelOneTap: @escaping (() -> Void), exitCheckout: @escaping (() -> Void)) {
        pxNavigationHandler = navigationController
        finishOneTapCallback = finishOneTap
        cancelOneTapCallback = cancelOneTap
        exitCheckoutCallback = exitCheckout
        viewModel = OneTapFlowViewModel(paymentData: paymentData, checkoutPreference: checkoutPreference, search: search, paymentOptionSelected: paymentOptionSelected, reviewScreenPreference: reviewScreenPreference)
    }

    deinit {
        #if DEBUG
            print("DEINIT FLOW - \(self)")
        #endif
    }

    func setPaymentFlow(paymentFlow: PaymentFlow, callback: @escaping ((PaymentResult) -> Void)) {
        viewModel.paymentFlow = paymentFlow
        viewModel.finishOneTapWithPaymentResultCallback = callback
    }

    func setPaymentFlow() {
        guard let paymentFlow = viewModel.paymentFlow else {
            return
        }
        paymentFlow.setData(paymentData: viewModel.paymentData, checkoutPreference: viewModel.checkoutPreference, finishWithPaymentResultCallback: { [weak self] (paymentResult) in
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            if paymentResult.isApproved() {
                PXNotificationManager.Post.animateButtonForSuccess()
            } else {
                PXNotificationManager.Post.animateButtonForError()
            }
                self?.viewModel.paymentResult = paymentResult
//            })
        })
        paymentFlow.start()

//        self.viewModel.finishOneTapWithPaymentResultCallback?(PaymentResult(status: "approved", statusDetail: "String", paymentData: viewModel.paymentData, payerEmail: nil, paymentId: nil, statementDescription: nil))
    }

    func start() {
        executeNextStep()
    }

    func executeNextStep() {
        switch self.viewModel.nextStep() {
        case .screenReviewOneTap:
            self.showReviewAndConfirmScreenForOneTap()
        case .screenSecurityCode:
            self.showSecurityCodeScreen()
        case .serviceCreateESCCardToken:
            self.createCardToken()
        case .payment:
            self.setPaymentFlow()
        case .finish:
            self.finishFlow()
        }
    }

    // Cancel one tap and go to checkout
    func cancelFlow() {
        viewModel.search.deleteCheckoutDefaultOption()
        cancelOneTapCallback()
    }

    // Finish one tap and continue with checkout
    func finishFlow() {
        viewModel.search.deleteCheckoutDefaultOption()
        finishOneTapCallback(viewModel.paymentData)
    }

    // Exit checkout
    func exitCheckout() {
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
    static func autoSelectOneTapOption(search: PaymentMethodSearch, paymentMethodPlugins: [PXPaymentMethodPlugin], forceTest: Bool = false) -> PaymentMethodOption? {

        if forceTest {
            return MockPaymentOption()
        }

        var selectedPaymentOption: PaymentMethodOption?
        if search.hasCheckoutDefaultOption() {
            // Check if can autoselect plugin
            let paymentMethodPluginsFound = paymentMethodPlugins.filter { (paymentMethodPlugin: PXPaymentMethodPlugin) -> Bool in
                return paymentMethodPlugin.getId() == search.oneTap?.paymentMethodId
            }
            if let paymentMethodPlugin = paymentMethodPluginsFound.first {
                selectedPaymentOption = paymentMethodPlugin
            } else {
                // Check if can autoselect customer card
                guard let customerPaymentMethods = search.customerPaymentMethods else {
                    return nil
                }
                let customOptionsFound = customerPaymentMethods.filter { (cardInformation: CardInformation) -> Bool in
                    return cardInformation.getCardId() == search.oneTap?.oneTapCard?.cardId
                }
                if let customerPaymentMethod = customOptionsFound.first, let customerPaymentOption = customerPaymentMethod as? PaymentMethodOption {
                    // Check if one tap response has payer costs
                    if let oneTap = search.oneTap, oneTap.oneTapCard?.selectedPayerCost != nil {
                        // Check if card found has same paymentmethod as One tap response
                        if oneTap.paymentMethodId == customerPaymentMethod.getPaymentMethodId() && oneTap.paymentTypeId == customerPaymentMethod.getPaymentTypeId() {
                            selectedPaymentOption = customerPaymentOption
                        }
                    }
                }}
        }
        return selectedPaymentOption
    }
}

// TODO: Only for test flow. Remove before merge.
class MockPaymentOption: PaymentMethodOption {

    func getId() -> String {
        return "rapipago"
    }

    func getDescription() -> String {
        return "Rapipago mocked payment method"
    }

    func getComment() -> String {
        return ""
    }

    func hasChildren() -> Bool {
        return false
    }

    func getChildren() -> [PaymentMethodOption]? {
        return nil
    }

    func isCard() -> Bool {
        return false
    }

    func isCustomerPaymentMethod() -> Bool {
        return false
    }
}
