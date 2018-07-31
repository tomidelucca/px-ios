//
//  PXToDeprecate.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 31/7/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

// MARK: To deprecate v4 final signs.
extension MercadoPagoCheckout {
    @available(*, deprecated, message: "Use PXAdvancedConfigurationProtocol instead.")
    open static func setFlowPreference(_ flowPreference: FlowPreference) {
    }
}

// MARK: To deprecate v4 - Classes
@objcMembers open class FlowPreference: NSObject {
    @available(*, deprecated, message: "Use PXAdvancedConfigurationProtocol instead.")
    public func disableESC() {

    }

    @available(*, deprecated, message: "Use PXAdvancedConfigurationProtocol instead.")
    public func enableESC() {

    }

    @available(*, deprecated, message: "Use PXAdvancedConfigurationProtocol instead.")
    public func isESCEnable() -> Bool {
        return false
    }
}
