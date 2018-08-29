//
//  PXPaymentData.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 2/1/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

@objcMembers public class PXPaymentData: NSObject, NSCopying {

    internal var paymentMethod: PaymentMethod?
    internal var issuer: Issuer?
    internal var payerCost: PayerCost?
    internal var token: Token?
    internal var payer: Payer?
    internal var transactionDetails: TransactionDetails?
    internal private(set) var discount: PXDiscount?
    internal private(set) var campaign: PXCampaign?
    private let paymentTypesWithoutInstallments = [PXPaymentTypes.PREPAID_CARD.rawValue]

    /// :nodoc:
    public func copy(with zone: NSZone? = nil) -> Any {
        let copyObj = PXPaymentData()
        copyObj.paymentMethod = paymentMethod
        copyObj.issuer = issuer
        copyObj.payerCost = payerCost
        copyObj.token = token
        copyObj.payerCost = payerCost
        copyObj.transactionDetails = transactionDetails
        copyObj.discount = discount
        copyObj.campaign = campaign
        copyObj.payer = payer
        return copyObj
    }

    internal func isComplete(shouldCheckForToken: Bool = true) -> Bool {

        guard let paymentMethod = self.paymentMethod else {
            return false
        }

        if paymentMethod.isEntityTypeRequired && payer?.entityType == nil {
            return false
        }

        if paymentMethod.isPayerInfoRequired && payer?.identification == nil {
            return false
        }

        if !Array.isNullOrEmpty(paymentMethod.financialInstitutions) && transactionDetails?.financialInstitution == nil {
            return false
        }

        if paymentMethod.paymentMethodId == PXPaymentTypes.ACCOUNT_MONEY.rawValue || !paymentMethod.isOnlinePaymentMethod {
            return true
        }

        if paymentMethod.isIssuerRequired && self.issuer == nil {
            return false
        }

        if paymentMethod.isCard && payerCost == nil &&
            !paymentTypesWithoutInstallments.contains(paymentMethod.paymentTypeId) {
            return false
        }

        if paymentMethod.isCard && !hasToken() && shouldCheckForToken {
            return false
        }
        return true
    }

    internal func hasToken() -> Bool {
        return token != nil
    }

    internal func hasIssuer() -> Bool {
        return issuer != nil
    }

    internal func hasPayerCost() -> Bool {
        return payerCost != nil
    }

    internal func hasPaymentMethod() -> Bool {
        return paymentMethod != nil
    }

    internal func hasCustomerPaymentOption() -> Bool {
        return hasPaymentMethod() && (self.paymentMethod!.isAccountMoney || (hasToken() && !String.isNullOrEmpty(self.token!.cardId)))
    }
}

// MARK: Getters
extension PXPaymentData {
    public func getToken() -> Token? {
        return token
    }

    public func getPayerCost() -> PayerCost? {
        return payerCost
    }

    public func getNumberOfInstallments() -> Int {
        guard let installments = payerCost?.installments else {
            return 0
        }
        return installments
    }

    public func getIssuer() -> Issuer? {
        return issuer
    }

    public func getPayer() -> Payer? {
        return payer
    }

    public func getPaymentMethod() -> PaymentMethod? {
        return paymentMethod
    }

    public func getDiscount() -> PXDiscount? {
        return discount
    }
}

// MARK: Setters
extension PXPaymentData {
    internal func setDiscount(_ discount: PXDiscount, withCampaign campaign: PXCampaign) {
        self.discount = discount
        self.campaign = campaign
    }

    internal func updatePaymentDataWith(paymentMethod: PaymentMethod?) {
        guard let paymentMethod = paymentMethod else {
            return
        }
        cleanIssuer()
        cleanToken()
        cleanPayerCost()
        self.paymentMethod = paymentMethod
    }

    internal func updatePaymentDataWith(token: Token?) {
        guard let token = token else {
            return
        }
        self.token = token
    }

    internal func updatePaymentDataWith(payerCost: PayerCost?) {
        guard let payerCost = payerCost else {
            return
        }
        self.payerCost = payerCost
    }

    internal func updatePaymentDataWith(issuer: Issuer?) {
        guard let issuer = issuer else {
            return
        }
        cleanPayerCost()
        self.issuer = issuer
    }

    internal func updatePaymentDataWith(payer: Payer?) {
        guard let payer = payer else {
            return
        }
        self.payer = payer
    }
}

// MARK: Clears
extension PXPaymentData {
    internal func cleanToken() {
        self.token = nil
    }

    internal func cleanPayerCost() {
        self.payerCost = nil
    }

    internal func cleanIssuer() {
        self.issuer = nil
    }

    internal func cleanPaymentMethod() {
        self.paymentMethod = nil
    }

    internal func clearCollectedData() {
        self.paymentMethod = nil
        self.issuer = nil
        self.payerCost = nil
        self.token = nil
        self.payer?.clearCollectedData() // No borrar el payer directo
        self.transactionDetails = nil
        // No borrar el descuento
    }

    internal func clearDiscount() {
        self.discount = nil
        self.campaign = nil
    }
}

// MARK: JSON
extension PXPaymentData {
    internal func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }

    internal func toJSON() -> [String: Any] {
        var obj: [String: Any] = [
            "payer": payer?.toJSON() ?? ""
        ]
        if let paymentMethod = self.paymentMethod {
            obj["payment_method"] = paymentMethod.toJSON()
        }

        if let payerCost = self.payerCost {
            obj["payer_cost"] = payerCost.toJSON()
        }

        if let token = self.token {
            obj["card_token"] = token.toJSON()
        }

        if let issuer = self.issuer {
            obj["issuer"] = issuer.toJSON()
        }

        if let discount = self.discount {
            obj["discount"] = discount.toJSONDictionary()
        }

        return obj
    }
}
