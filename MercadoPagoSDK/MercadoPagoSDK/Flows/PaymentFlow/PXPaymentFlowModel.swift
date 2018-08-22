//
//  PXPaymentFlowModel.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 16/07/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

internal final class PXPaymentFlowModel: NSObject {
    var paymentData: PaymentData?
    var checkoutPreference: CheckoutPreference?
    let paymentPlugin: PXPaymentProcessor?

    let mercadoPagoServicesAdapter: MercadoPagoServicesAdapter

    var paymentResult: PaymentResult?
    var instructionsInfo: InstructionsInfo?
    var businessResult: PXBusinessResult?

    init(paymentPlugin: PXPaymentProcessor?, mercadoPagoServicesAdapter: MercadoPagoServicesAdapter) {
        self.paymentPlugin = paymentPlugin
        self.mercadoPagoServicesAdapter = mercadoPagoServicesAdapter
    }

    enum Steps: String {
        case createPaymentPlugin
        case createDefaultPayment
        case getInstructions
        case createPaymentPluginScreen
        case finish
    }

    func nextStep() -> Steps {
        if needToCreatePaymentForPaymentPlugin() {
            return .createPaymentPlugin
        } else if needToShowPaymentPluginScreenForPaymentPlugin() {
            return .createPaymentPluginScreen
        } else if needToCreatePayment() {
            return .createDefaultPayment
        } else if needToGetInstructions() {
            return .getInstructions
        } else {
            return .finish
        }
    }

    func needToCreatePaymentForPaymentPlugin() -> Bool {
        if paymentPlugin == nil {
            return false
        }

        if !needToCreatePayment() {
            return false
        }

        assignToCheckoutStore()

        if hasPluginPaymentScreen(plugin: paymentPlugin) {
            return false
        }

        assignToCheckoutStore()
        if let shouldSkip = paymentPlugin?.support?(checkoutStore: PXCheckoutStore.sharedInstance), !shouldSkip {
            return false
        }
        return true
    }

    func needToCreatePayment() -> Bool {
        return paymentResult == nil && businessResult == nil
    }

    func needToGetInstructions() -> Bool {
        guard let paymentResult = self.paymentResult else {
            return false
        }

        guard !String.isNullOrEmpty(paymentResult.paymentId) else {
            return false
        }

        return isOfflinePayment() && instructionsInfo == nil
    }

    func needToShowPaymentPluginScreenForPaymentPlugin() -> Bool {
        if !needToCreatePayment() {
            return false
        }
       return hasPluginPaymentScreen(plugin: paymentPlugin)
    }

    func isOfflinePayment() -> Bool {
        guard let paymentTypeId = paymentData?.paymentMethod?.paymentTypeId else {
            return false
        }
        return !PaymentTypeId.isOnlineType(paymentTypeId: paymentTypeId)
    }

    func assignToCheckoutStore() {
        if let paymentData = paymentData {
            PXCheckoutStore.sharedInstance.paymentData = paymentData
        }
        PXCheckoutStore.sharedInstance.checkoutPreference = checkoutPreference
    }

    func cleanData() {
        paymentResult = nil
        businessResult = nil
        instructionsInfo = nil
    }
}

/** :nodoc: */
extension PXPaymentFlowModel {
    func hasPluginPaymentScreen(plugin: PXPaymentProcessor?) -> Bool {
        guard let paymentPlugin = plugin else {
            return false
        }
        assignToCheckoutStore()
        let view = paymentPlugin.render(store: PXCheckoutStore.sharedInstance, theme: ThemeManager.shared)
        return  view != nil
    }
}
