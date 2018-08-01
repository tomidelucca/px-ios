//
//  Cardholder.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import MercadoPagoServicesV4

@objcMembers open class Cardholder: NSObject {
    open var name: String?
    open var identification: PXIdentification!
}
