//
//  PXPayer+Business.swift
//  MercadoPagoSDKV4
//
//  Created by Eden Torres on 01/08/2018.
//

import Foundation

internal extension PXPayer {
    internal func clearCollectedData() {
        entityType = nil
        identification = nil
        firstName = nil
        lastName = nil
    }
}

// MARK: Tracking
extension PXPayer {
    func getPayerForTracking() -> [String: Any] {
        var payerDic: [String: Any] = [:]
        payerDic["email"] = email
        payerDic["name"] = firstName
        payerDic["lastname"] = lastName
        payerDic["identification"] = identification?.getIdentificationForTracking()
        return payerDic
    }
}
