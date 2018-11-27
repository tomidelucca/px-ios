//
//  PXPaymentMethodConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/11/18.
//

import UIKit

class PXPaymentMethodConfiguration: NSObject {
    let paymentMethodOption: PaymentMethodOption
    let paymentOptionsConfigurations: [PXPaymentOptionConfiguration]
    let defaultConfigurationIndex: Int
    init(paymentMethodOption: PaymentMethodOption, paymentOptionsConfigurations: [PXPaymentOptionConfiguration], defaultConfigurationIndex: Int = 0) {
        self.paymentMethodOption = paymentMethodOption
        self.paymentOptionsConfigurations = paymentOptionsConfigurations
        self.defaultConfigurationIndex = defaultConfigurationIndex
        super.init()
    }
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherConfiguration = object as? PXPaymentMethodConfiguration else {
            return false
        }
        return paymentMethodOption.getId() == otherConfiguration.paymentMethodOption.getId()
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
