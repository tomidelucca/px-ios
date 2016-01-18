//
//  PaymentType.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 13/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentType: NSObject {

    public static let allPaymentIDs : Set<PaymentTypeId> = [PaymentTypeId.DEBIT_CARD,PaymentTypeId.CREDIT_CARD,PaymentTypeId.ACCOUNT_MONEY,PaymentTypeId.TICKET,PaymentTypeId.BANK_TRANFER,PaymentTypeId.ATM,PaymentTypeId.DIGITAL_CURRENCY,PaymentTypeId.PREPAID_CARD]

    
    var paymentTypeId : PaymentTypeId!
    
    override public init(){
        super.init()
    }
    
    public class func fromJSON(json : NSDictionary) -> PaymentType {
        let paymentType = PaymentType()
        if json["id"] != nil && !(json["id"]! is NSNull) {
            
            paymentType.paymentTypeId = PaymentTypeId(rawValue: (json["id"]!.stringValue))
        }
        return paymentType
    }
}

public enum PaymentTypeId :String {
    case DEBIT_CARD = "debit_card"
    case CREDIT_CARD = "credit_card"
    case ACCOUNT_MONEY = "account_money"
    case TICKET = "ticket"
    case BANK_TRANFER = "bank_transfer"
    case ATM = "atm"
    case DIGITAL_CURRENCY = "digital_currency"
    case PREPAID_CARD = "prepaid_card"
}










