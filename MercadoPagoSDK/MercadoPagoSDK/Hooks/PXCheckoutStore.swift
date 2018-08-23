//
//  PXHookStore.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 11/28/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

@objcMembers
open class PXCheckoutStore: NSObject {
    static let sharedInstance = PXCheckoutStore()
    internal var checkoutPreference: CheckoutPreference?
    internal var paymentData = PaymentData()
    internal var paymentOptionSelected: PaymentMethodOption?
    private var data = [String: Any]()
}

// MARK: - Getters
extension PXCheckoutStore {
    public func getPaymentData() -> PaymentData {
        return paymentData
    }

    public func getCheckoutPreference() -> CheckoutPreference? {
        return checkoutPreference
    }

    public func getPaymentOptionSelected() -> PaymentMethodOption? {
        return paymentOptionSelected
    }
}

internal extension PXCheckoutStore {
    internal func clean() {
        removeAll()
        checkoutPreference = nil
        paymentData = PaymentData()
        paymentOptionSelected = nil
    }
}

internal extension PXCheckoutStore {
    internal func addData(forKey: String, value: Any) {
        self.data[forKey] = value
    }

    internal func remove(key: String) {
        data.removeValue(forKey: key)
    }

    internal func removeAll() {
        data.removeAll()
    }

    internal func getData(forKey: String) -> Any? {
        return self.data[forKey]
    }
}
