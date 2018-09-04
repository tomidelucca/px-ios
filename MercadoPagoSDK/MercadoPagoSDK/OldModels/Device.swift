//
//  Device.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

internal class Device {
    var fingerprint: PXFingerprint

    init() {
        self.fingerprint = PXFingerprint()
    }
}
