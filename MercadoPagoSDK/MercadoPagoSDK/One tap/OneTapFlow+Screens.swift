//
//  OneTapFlow+Screens.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 09/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

extension OneTapFlow {

    func showReviewAndConfirmScreenForOneTap() {
        let reviewVC = PXOneTapViewController(viewModel: viewModel.reviewConfirmViewModel(), callbackPaymentData: { [weak self] (paymentData: PaymentData) in

            self?.cancelFlow()
            return

            }, callbackConfirm: {(paymentData: PaymentData) in
                self.viewModel.updateCheckoutModel(paymentData: paymentData)

                // Deletes default one tap option in payment method search
                self.executeNextStep()

        }, callbackExit: { [weak self] () -> Void in
            guard let strongSelf = self else {
                return
            }
            strongSelf.cancelFlow()
            }, finishButtonAnimation: {
                guard let paymentResult = self.viewModel.paymentResult else {
                    self.pxNavigationHandler.showErrorScreen(error: MPSDKError(message: "Hubo un error".localized, errorDetail: "", retry: true), callbackCancel: {
                        self.setPaymentFlow()
                    }, errorCallback: {
                        self.exitCheckout()
                    })
                    return
                }
                self.viewModel.search.deleteCheckoutDefaultOption()
                self.viewModel.finishOneTapWithPaymentResultCallback?(paymentResult)
        })

        self.pxNavigationHandler.pushViewController(viewController: reviewVC, animated: true)
    }

    func showSecurityCodeScreen() {
        let securityCodeVc = SecurityCodeViewController(viewModel: viewModel.savedCardSecurityCodeViewModel(), collectSecurityCodeCallback: { [weak self] (cardInformation: CardInformationForm, securityCode: String) -> Void in
            self?.createCardToken(cardInformation: cardInformation as? CardInformation, securityCode: securityCode)
        })
        self.pxNavigationHandler.pushViewController(viewController: securityCodeVc, animated: true)
    }
}
