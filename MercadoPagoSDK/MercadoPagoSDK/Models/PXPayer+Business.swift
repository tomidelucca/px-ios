//
//  PXPayer+Business.swift
//  MercadoPagoSDKV4
//
//  Created by Eden Torres on 01/08/2018.
//

import Foundation
import MercadoPagoServicesV4

internal extension PXPayer {
    func clearCollectedData() {
        entityType = nil
        identification = nil
        firstName = nil
        lastName = nil
    }
}
