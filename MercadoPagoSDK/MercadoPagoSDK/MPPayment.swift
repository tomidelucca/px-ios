//
//  MPPayment.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 26/4/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l__?, r__?):
    return l__ < r__
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l__?, r__?):
    return l__ > r__
  default:
    return rhs < lhs
  }
}

internal class MPPayment {

    open var preferenceId: String!
    open var publicKey: String!
    open var paymentMethodId: String!
    open var installments: Int = 0
    open var issuerId: String?
    open var tokenId: String?
    open var payer: PXPayer?
    open var binaryMode: Bool = false
    open var transactionDetails: PXTransactionDetails?
    open var discount: PXDiscount?

    init(preferenceId: String, publicKey: String, paymentMethodId: String, installments: Int = 0, issuerId: String = "", tokenId: String = "", transactionDetails: PXTransactionDetails, payer: PXPayer, binaryMode: Bool, discount: PXDiscount? = nil) {
        self.preferenceId = preferenceId
        self.publicKey = publicKey
        self.paymentMethodId = paymentMethodId
        self.installments = installments
        self.issuerId = issuerId
        self.tokenId = tokenId
        self.transactionDetails = transactionDetails
        self.payer = payer
        self.binaryMode = binaryMode
        self.discount = discount
    }

    init(preferenceId: String, publicKey: String, paymentData: PXPaymentData, binaryMode: Bool) {
        self.issuerId = paymentData.hasIssuer() ? paymentData.getIssuer()!.id! : ""
        self.tokenId = paymentData.hasToken() ? paymentData.getToken()!.id : ""
        self.installments = paymentData.hasPayerCost() ? paymentData.getPayerCost()!.installments : 0

        if let transactionDetails = paymentData.transactionDetails {
            self.transactionDetails = transactionDetails
        }

        self.payer = PXPayer(email: "")
        if let targetPayer = paymentData.payer {
            self.payer = targetPayer
        }

        self.discount = paymentData.discount
        self.paymentMethodId = paymentData.getPaymentMethod()?.id ?? ""

        self.preferenceId = preferenceId
        self.publicKey = publicKey
        self.binaryMode = binaryMode

    }

    internal func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }

    internal func toJSON() -> [String: Any] {
        var obj: [String: Any] = [
            "public_key": self.publicKey,
            "payment_method_id": self.paymentMethodId,
            "pref_id": self.preferenceId,
            "binary_mode": self.binaryMode,
            "payer" : ["email": self.payer?.email]
            ]

        if self.tokenId != nil && self.tokenId?.count > 0 {
            obj["token"] = self.tokenId!
        }

        obj["installments"] = self.installments

        if self.issuerId != nil && self.issuerId?.count > 0 {
            obj["issuer_id"] = self.issuerId
        }

//        if self.transactionDetails != nil {
//            obj["transaction_details"] = self.transactionDetails?.toJSON()
//        }
        if let discount = self.discount {
            obj["campaign_id"] = discount.id
            obj["coupon_amount"] = discount.couponAmount
        }

        return obj
    }
}
