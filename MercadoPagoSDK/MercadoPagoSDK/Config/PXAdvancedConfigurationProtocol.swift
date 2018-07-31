//
//  PXAdvancedConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 30/7/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

public protocol PXAdvancedConfigurationProtocol {
    var bankDealsEnabled: Bool { get set }
    var escEnabled: Bool { get set }
}

extension PXAdvancedConfigurationProtocol {
    var bankDealsEnabled: Bool {
        get { return true } set { }
    }

    var escEnabled: Bool {
        get { return false } set { }
    }
}

final class PXAdvancedConfiguration: PXAdvancedConfigurationProtocol {
}
