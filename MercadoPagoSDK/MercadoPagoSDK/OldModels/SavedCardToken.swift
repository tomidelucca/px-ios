//
//  SavedCard.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

internal class SavedCardToken: CardToken {

    open var cardId: String
    open var securityCodeRequired: Bool = true

    public init(cardId: String, securityCode: String) {
        self.cardId = cardId
        super.init()
        self.securityCode = securityCode
    }

    internal init(cardId: String) {
        self.cardId = cardId
        super.init()
        self.device = Device()
    }

    public init(card: PXCardInformation, securityCode: String?, securityCodeRequired: Bool) {
        self.cardId = card.getCardId()
        super.init()
        self.securityCode = securityCode
        self.securityCodeRequired = securityCodeRequired
        self.device = Device()
    }

    open override func validate() -> Bool {
        return self.validateCardId() && (!securityCodeRequired || self.validateSecurityCodeNumbers())
    }

    open func validateCardId() -> Bool {
        return !String.isNullOrEmpty(cardId) && String.isDigitsOnly(cardId)
    }

    open func validateSecurityCodeNumbers() -> Bool {
        let isEmptySecurityCode: Bool = String.isNullOrEmpty(self.securityCode)
        return !isEmptySecurityCode && self.securityCode!.count >= 3 && self.securityCode!.count <= 4
    }

    open override func isCustomerPaymentMethod() -> Bool {
        return true
    }
}
