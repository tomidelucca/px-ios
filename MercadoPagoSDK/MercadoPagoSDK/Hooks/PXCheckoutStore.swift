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
    internal var checkoutPreference: PXCheckoutPreference?
    internal var paymentData = PXPaymentData()
    private var data = [String: Any]()
}

// MARK: - Getters
extension PXCheckoutStore {
    public func getPaymentData() -> PXPaymentData {
        return paymentData
    }

    public func getCheckoutPreference() -> PXCheckoutPreference? {
        return checkoutPreference
    }
}

// MARK: - DataStore
extension PXCheckoutStore {
    public func addData(forKey: String, value: Any) {
        self.data[forKey] = value
    }

    public func remove(key: String) {
        data.removeValue(forKey: key)
    }

    public func removeAll() {
        data.removeAll()
    }

    public func getData(forKey: String) -> Any? {
        return self.data[forKey]
    }
}

internal extension PXCheckoutStore {
    internal func clean() {
        removeAll()
        checkoutPreference = nil
        paymentData = PXPaymentData()
    }
}
