//
//  PXCardDataFactory.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 16/10/18.
//

import Foundation

internal class PXCardDataFactory: NSObject, CardData {
    var name = ""
    var number = ""
    var securityCode = ""
    var expiration = ""

    func create(cardName: String, cardNumber: String, cardCode: String, cardExpiration: String) -> PXCardDataFactory {
        self.name = cardName
        self.number = cardNumber
        self.securityCode = cardCode
        self.expiration = cardExpiration
        return self
    }
}
