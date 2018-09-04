//
//  SavedESCCardToken.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 7/20/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

internal class SavedESCCardToken: SavedCardToken {
    open var requireESC: Bool = false
    open var esc: String?

    init (cardId: String, securityCode: String?, requireESC: Bool) {
        super.init(cardId: cardId)
        self.securityCode = securityCode
        self.cardId = cardId
        self.requireESC = requireESC
        self.device = PXDevice()
    }

    init (cardId: String, esc: String?, requireESC: Bool) {
        super.init(cardId: cardId)
        self.securityCode = ""
        self.cardId = cardId
        self.requireESC = requireESC
        self.esc = esc
        self.device = PXDevice()
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
