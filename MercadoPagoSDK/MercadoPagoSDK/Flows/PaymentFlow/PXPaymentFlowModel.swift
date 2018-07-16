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
    let binaryMode: Bool
    let paymentPlugin: PXPaymentPluginComponent?
    let paymentMethodPaymentPlugin: PXPaymentPluginComponent?
    let mercadoPagoServicesAdapter: MercadoPagoServicesAdapter

    var paymentResult: PaymentResult?
    var instructionsInfo: InstructionsInfo?
    var businessResult: PXBusinessResult?

    init(paymentPlugin: PXPaymentPluginComponent?, paymentMethodPaymentPlugin: PXPaymentPluginComponent?, binaryMode: Bool, mercadoPagoServicesAdapter: MercadoPagoServicesAdapter) {
        self.paymentPlugin = paymentPlugin
        self.paymentMethodPaymentPlugin = paymentMethodPaymentPlugin
        self.binaryMode = binaryMode
        self.mercadoPagoServicesAdapter = mercadoPagoServicesAdapter
    }

    enum Steps: String {
        case createPaymentPlugin
        case createPaymentMethodPaymentPlugin
        case createDefaultPayment
        case getInstructions
        case finish
    }

    func nextStep() -> Steps {
        if needToCreatePaymentForPaymentPlugin() {
            return .createPaymentPlugin
        } else if needToCreatePaymentForPaymentMethodPaymentPlugin() {
            return .createPaymentMethodPaymentPlugin
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
        if let shouldSkip = paymentPlugin?.support?(pluginStore: PXCheckoutStore.sharedInstance), !shouldSkip {
            return false
        }
        return true
    }

    func needToCreatePaymentForPaymentMethodPaymentPlugin() -> Bool {
        if paymentMethodPaymentPlugin == nil {
            return false
        }

        if !needToCreatePayment() {
            return false
        }

        assignToCheckoutStore()
        return self.paymentData?.paymentMethod?.paymentTypeId == PaymentTypeId.PAYMENT_METHOD_PLUGIN.rawValue
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
}
