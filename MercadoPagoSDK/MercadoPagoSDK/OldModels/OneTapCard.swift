//
//  OneTapCard.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServicesV4

internal class OneTapCard {
    open var cardId: String
    open var selectedPayerCost: PXPayerCost?

    public init(cardId: String, selectedPayerCost: PXPayerCost?) {
        self.cardId = cardId
        self.selectedPayerCost = selectedPayerCost
    }
}
