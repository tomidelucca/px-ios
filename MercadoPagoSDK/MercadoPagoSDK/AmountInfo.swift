//
//  PaymentInfo.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 29/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoServicesV4

@objcMembers open class AmountInfo: NSObject {

    var amount: Double!
    var currency: PXCurrency!

    override init() {
        super.init()
    }

}
