//
//  MercadoPagoCheckoutViewModel+Hooks.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 11/28/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//
import Foundation

internal extension MercadoPagoCheckoutViewModel {

    func shouldShowPreReviewScreen() -> Bool {

        guard let pm = self.paymentData.getPaymentMethod(), !wasPreReviewScreenShowned(), !readyToPay else {
            return false
        }

        if pm.isCreditCard && !(paymentData.hasPayerCost() && paymentData.hasToken()) {
            return false
        }

        if (pm.isDebitCard || pm.isPrepaidCard) && !paymentData.hasToken() {
            return false
        }

        if pm.isPayerInfoRequired && paymentData.getPayer()?.identification == nil {
            return false
        }
        return true
    }

    func wasPreReviewScreenShowned() -> Bool {
        let reviewScreens = self.pxNavigationHandler.navigationController.viewControllers.filter {$0.isKind(of: PXReviewViewController.self)}
        let preReviewScreens = self.pxNavigationHandler.navigationController.viewControllers.filter {$0 as? PXPreReviewScreen != nil}
        return preReviewScreens.count != reviewScreens.count
    }
}
