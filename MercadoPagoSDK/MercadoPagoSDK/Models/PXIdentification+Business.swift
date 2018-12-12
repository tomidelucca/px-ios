//
//  PXIdentification+Business.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 07/12/2018.
//

import Foundation

// MARK: Tracking
extension PXIdentification {
    func getIdentificationForTracking() -> [String: Any] {
        var identificationDic: [String: Any] = [:]
        identificationDic["number"] = number
        identificationDic["type"] = type
        return identificationDic
    }
}
