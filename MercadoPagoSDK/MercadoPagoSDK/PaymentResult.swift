//
//  PaymentResult.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
open class PaymentResult: NSObject {
    var paymentData: PaymentData?
    var status: String
    var statusDetail: String
    var currencyId: String?
    var payerEmail: String?
    var _id: String?
    var amount: Double?
    var statementDescription: String?
    
    init (status: String, statusDetail: String, paymentData: PaymentData?, currencyId: String?, payerEmail:String?, id: String?, amount: Double?, statementDescription: String?){
        self.status = status
        self.statusDetail = statusDetail
        self.paymentData = paymentData
        self.currencyId = currencyId
        self.payerEmail = payerEmail
        self._id = id
        self.amount = amount
        self.statementDescription = statementDescription
    }
    
    init (payment: Payment, paymentData: PaymentData?){
        self.status = payment.status
        self.statusDetail = payment.statusDetail
        self.paymentData = paymentData
        self.currencyId = payment.currencyId
        self._id = payment._id
        self.amount = payment.transactionAmount
        self.payerEmail = payment.payer.email
        self.statementDescription = payment.statementDescriptor
    }
}
