//
//  PXPaymentMethodConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/11/18.
//

import UIKit

class PXPaymentMethodConfiguration: NSObject {
    let paymentOptionID: String
    let paymentOptionsConfigurations: [PXPaymentOptionConfiguration]
    let selectedAmountConfiguration: String
    init(paymentOptionID: String, paymentOptionsConfigurations: [PXPaymentOptionConfiguration], selectedAmountConfiguration: String) {
        self.paymentOptionID = paymentOptionID
        self.paymentOptionsConfigurations = paymentOptionsConfigurations
        self.selectedAmountConfiguration = selectedAmountConfiguration
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherConfiguration = object as? PXPaymentMethodConfiguration else {
            return false
        }
        return paymentOptionID == otherConfiguration.paymentOptionID
    }
}

class PXPaymentOptionConfiguration: NSObject {
    let id: String
    let discountConfiguration: PXDiscountConfiguration?
    let payerCostConfiguration: PXPayerCostConfiguration?
    init(id: String, discountConfiguration: PXDiscountConfiguration? = nil, payerCostConfiguration: PXPayerCostConfiguration? = nil) {
        self.id = id
        self.discountConfiguration = discountConfiguration
        self.payerCostConfiguration = payerCostConfiguration
        super.init()
    }
}
