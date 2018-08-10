//
//  PXPaymentConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 10/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServicesV4

@objcMembers
open class PXPaymentConfiguration: NSObject {
    private var discountConfiguration: PXDiscountConfiguration?
    private var chargeRules: [PXPaymentTypeChargeRule]?

    public init(discountConfiguration: PXDiscountConfiguration?, chargeRules: [PXPaymentTypeChargeRule]?) {
        self.discountConfiguration = discountConfiguration
        self.chargeRules = chargeRules
    }
}

extension PXPaymentConfiguration {
    internal func getPaymentConfiguration() -> (discountConfiguration: PXDiscountConfiguration?, chargeRules: [PXPaymentTypeChargeRule]?) {
        return (discountConfiguration, chargeRules)
    }
}
