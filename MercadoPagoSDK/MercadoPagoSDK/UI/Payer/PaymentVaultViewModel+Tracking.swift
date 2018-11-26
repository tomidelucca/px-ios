//
//  PaymentVaultViewModel+Tracking.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 26/11/2018.
//

import Foundation
// MARK: Tracking
extension PaymentVaultViewModel {
    func getAvailablePaymentMethodForTracking() -> [Any] {
        var dic: [Any] = []
        if isRoot {
            for plugin in paymentMethodPlugins {
                var pluginDic: [String: Any] = [:]
                pluginDic["payment_method_type"] = plugin.paymentMethodPluginId
                pluginDic["payment_method_id"] = plugin.paymentMethodPluginId
                dic.append(pluginDic)
            }
            if let customerPaymentOptions = customerPaymentOptions {
                let cardIdsEsc = PXTrackingStore.sharedInstance.getData(forKey: PXTrackingStore.cardIdsESC) as? [String] ?? []
                for savedCard in customerPaymentOptions {
                    var savedCardDic: [String: Any] = [:]
                    savedCardDic["payment_method_type"] = savedCard.getPaymentTypeId()
                    savedCardDic["payment_method_id"] = savedCard.getPaymentMethodId()
                    var extraInfo: [String: Any] = [:]
                    extraInfo["card_id"] = savedCard.getCardId()
                    extraInfo["has_esc"] = cardIdsEsc.contains(savedCard.getCardId())
                    extraInfo["saved"] = true
                    savedCardDic["extra_info"] = extraInfo
                    dic.append(savedCardDic)
                }
            }
        }
        for paymentOption in paymentMethodOptions {
            var paymentOptionDic: [String: Any] = [:]
            if paymentOption.getPaymentType() == "payment_method" {
                let filterPaymentMethods = paymentMethods.filter {paymentOption.getId().startsWith($0.id)}
                if let paymentMethod = filterPaymentMethods.first {
                    paymentOptionDic["payment_method_id"] = paymentOption.getId()
                    paymentOptionDic["payment_method_type"] = paymentMethod.paymentTypeId
                }
            } else {
                paymentOptionDic["payment_method_type"] = paymentOption.getId()
            }
            dic.append(paymentOptionDic)
        }
        return dic
    }
}
