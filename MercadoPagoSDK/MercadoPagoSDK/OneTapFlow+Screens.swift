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
        let reviewVC = PXReviewViewController(viewModel: viewModel.reviewConfirmViewModel(), showCustomComponents: false, callbackPaymentData: { [weak self] (paymentData: PaymentData) in

            // One tap
            if let search = self?.viewModel.search {
                search.deleteCheckoutDefaultOption()
            }
            self?.cancel()

            if !paymentData.hasPaymentMethod() && MercadoPagoCheckoutViewModel.changePaymentMethodCallback != nil {
                MercadoPagoCheckoutViewModel.changePaymentMethodCallback!()
            }
            return

            }, callbackConfirm: {(paymentData: PaymentData) in
                self.viewModel.updateCheckoutModel(paymentData: paymentData)

                if MercadoPagoCheckoutViewModel.paymentDataConfirmCallback != nil {
                    MercadoPagoCheckoutViewModel.paymentDataCallback = MercadoPagoCheckoutViewModel.paymentDataConfirmCallback
                    self.finish()
                } else {
                    self.executeNextStep()
                }

        }, callbackExit: { [weak self] () -> Void in
            guard let strongSelf = self else {
                return
            }
            strongSelf.cancel()
        })

        self.pxNavigationController.pushViewController(viewController: reviewVC, animated: true)
    }

    func showSecurityCodeScreen() {
        let securityCodeVc = SecurityCodeViewController(viewModel: viewModel.savedCardSecurityCodeViewModel(), collectSecurityCodeCallback: { [weak self] (cardInformation: CardInformationForm, securityCode: String) -> Void in
            self?.createCardToken(cardInformation: cardInformation as? CardInformation, securityCode: securityCode)
        })
        self.pxNavigationController.pushViewController(viewController: securityCodeVc, animated: true)
    }
}
