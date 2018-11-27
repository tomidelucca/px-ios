//
//  PXPaymentMethodConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/11/18.
//

import UIKit

class PXPaymentMethodConfiguration: NSObject {
    let paymentMethod: PXPaymentMethod
    let paymentOptionsConfigurations: [PXPaymentOptionConfiguration]
    let defaultConfigurationIndex: Int
    init(paymentMethod: PXPaymentMethod, paymentOptionsConfigurations: [PXPaymentOptionConfiguration], defaultConfigurationIndex: Int = 0) {
        self.paymentMethod = paymentMethod
        self.paymentOptionsConfigurations = paymentOptionsConfigurations
        self.defaultConfigurationIndex = defaultConfigurationIndex
        super.init()
    }
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherConfiguration = object as? PXPaymentMethodConfiguration else {
            return false
        }
        return paymentMethod.id == otherConfiguration.paymentMethod.id
    }
}

class PXPaymentOptionConfiguration: NSObject {
    let discountConfiguration: (discount:PXDiscount, campaign:PXCampaign)?
    let installment: PXInstallment?
    init(discountConfiguration:(discount:PXDiscount, campaign:PXCampaign)? = nil, installment: PXInstallment? = nil) {
        self.discountConfiguration = discountConfiguration
        self.installment = installment
        super.init()
    }
}
