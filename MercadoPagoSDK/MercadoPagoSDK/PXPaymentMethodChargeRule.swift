//
//  PXPaymentMethodChargeRule.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 13/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

@objc
public class PXPaymentMethodChargeRule: NSObject {

    let paymentMethdodId: String
    let amountCharge: Double
    
   @objc
    init(paymentMethdodId: String, amountCharge: Double) {
        self.paymentMethdodId = paymentMethdodId
        self.amountCharge = amountCharge
        super.init()
    }
}
