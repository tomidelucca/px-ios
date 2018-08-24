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
    internal var paymentData = PXPaymentData()
    private var data = [String: Any]()
}

// MARK: - Getters
extension PXCheckoutStore {
    public func getPaymentData() -> PXPaymentData {
        return paymentData
    }

    public func getCheckoutPreference() -> CheckoutPreference? {
        return checkoutPreference
    }
}

internal extension PXCheckoutStore {
    internal func clean() {
        removeAll()
        checkoutPreference = nil
        paymentData = PXPaymentData()
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
