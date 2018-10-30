//
//  PXPayerData.swift
//  MercadoPagoSDK
//
//  Created by Marcelo Oscar José on 30/10/2018.
//

import Foundation

internal struct PXPayerData {
    internal var firstName: String?
    internal var lastName: String?
    internal var identificationType: String?
    internal var identificationNumber: String?

    init(payer: PXPayer?) {
        if let payerData = payer, let payerId = payerData.identification {
            self.firstName = payerData.firstName
            self.lastName = payerData.lastName
            self.identificationType = payerId.type
            self.identificationNumber = payerId.number
        }
    }
}
