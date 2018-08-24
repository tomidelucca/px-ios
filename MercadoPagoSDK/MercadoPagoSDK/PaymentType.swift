//
//  PaymentType.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 13/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

@objcMembers internal class PaymentType: NSObject {

    open static let allPaymentIDs: Set<String> = [PXPaymentTypes.DEBIT_CARD.rawValue, PXPaymentTypes.CREDIT_CARD.rawValue, PXPaymentTypes.ACCOUNT_MONEY.rawValue, PXPaymentTypes.TICKET.rawValue, PXPaymentTypes.BANK_TRANSFER.rawValue, PXPaymentTypes.ATM.rawValue, PXPaymentTypes.BITCOIN.rawValue, PXPaymentTypes.PREPAID_CARD.rawValue, PXPaymentTypes.BOLBRADESCO.rawValue]

    var paymentTypeId: PXPaymentTypes!

    override public init() {
        super.init()
    }

    init(paymentTypeId: PXPaymentTypes) {
        super.init()
        self.paymentTypeId = paymentTypeId
    }

    internal static func fromJSON(_ json: NSDictionary) -> PaymentType {
                let paymentType = PaymentType()
                if let paymentTypeId = JSONHandler.attemptParseToString(json["id"]) {
                        paymentType.paymentTypeId = PXPaymentTypes(rawValue: paymentTypeId)
                    }
                return paymentType
            }

}
