//
//  Device.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

@objcMembers internal class Device: NSObject {
    var fingerprint: Fingerprint!

    override init() {
        super.init()
        self.fingerprint = Fingerprint()
    }

    internal func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }

    internal func toJSON() -> [String: Any] {
        let finger: [String: Any] = self.fingerprint.toJSON()
        let obj: [String: Any] = [
            "fingerprint": finger
        ]
        return obj
    }
}
