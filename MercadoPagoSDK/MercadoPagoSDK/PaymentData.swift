//
//  PaymentData.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 2/1/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoServicesV4

/** :nodoc: */
@objcMembers public class PaymentData: NSObject, NSCopying {

    public var paymentMethod: PXPaymentMethod?
    public var issuer: PXIssuer?
    public var payerCost: PXPayerCost?
    public var token: PXToken?
    public var payer: PXPayer?
    public var transactionDetails: PXTransactionDetails?
    public private(set) var discount: PXDiscount?
    public private(set) var campaign: PXCampaign?
    private let paymentTypesWithoutInstallments = [PaymentTypeId.DEBIT_CARD.rawValue, PaymentTypeId.PREPAID_CARD.rawValue]

    /**
     Este metodo deberia borrar SOLO la data recolectada atraves del flujo de Checkout,
     i.e. la data ingresada por el payer 
     */
    func clearCollectedData() {
        self.paymentMethod = nil
        self.issuer = nil
        self.payerCost = nil
        self.token = nil
        self.payer?.clearCollectedData() // No borrar el payer directo
        self.transactionDetails = nil
        // No borrar el descuento
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copyObj = PaymentData()
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

    func isComplete(shouldCheckForToken: Bool = true) -> Bool {

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

        if paymentMethod.paymentMethodId == PaymentTypeId.ACCOUNT_MONEY.rawValue || !paymentMethod.isOnlinePaymentMethod {
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

    func hasToken() -> Bool {
        return token != nil
    }

    func hasIssuer() -> Bool {
        return issuer != nil
    }

    func hasPayerCost() -> Bool {
        return payerCost != nil
    }

    func hasPaymentMethod() -> Bool {
        return paymentMethod != nil
    }

    func hasCustomerPaymentOption() -> Bool {
        return hasPaymentMethod() && (self.paymentMethod!.isAccountMoney || (hasToken() && !String.isNullOrEmpty(self.token!.cardId)))
    }

    public func updatePaymentDataWith(paymentMethod: PXPaymentMethod?) {
        guard let paymentMethod = paymentMethod else {
            return
        }
        cleanIssuer()
        cleanToken()
        cleanPayerCost()
        self.paymentMethod = paymentMethod
    }

    public func updatePaymentDataWith(token: PXToken?) {
        guard let token = token else {
            return
        }
        self.token = token
    }

    public func updatePaymentDataWith(payerCost: PXPayerCost?) {
        guard let payerCost = payerCost else {
            return
        }
        self.payerCost = payerCost
    }

    public func updatePaymentDataWith(issuer: PXIssuer?) {
        guard let issuer = issuer else {
            return
        }
        cleanPayerCost()
        self.issuer = issuer
    }

    public func updatePaymentDataWith(payer: PXPayer?) {
        guard let payer = payer else {
            return
        }
        self.payer = payer
    }

    public func cleanToken() {
        self.token = nil
    }

    public func cleanPayerCost() {
        self.payerCost = nil
    }

    func cleanIssuer() {
        self.issuer = nil
    }

    func cleanPaymentMethod() {
        self.paymentMethod = nil
    }

   public func getToken() -> PXToken? {
        return token
    }

    public func getPayerCost() -> PXPayerCost? {
        return payerCost
    }

    public func getNumberOfInstallments() -> Int {
        guard let installments = payerCost?.installments else {
            return 0
        }
        return installments
    }

    public func getIssuer() -> PXIssuer? {
        return issuer
    }

    public func getPayer() -> PXPayer {
        var returnedPayer = PXPayer()
        if let payer = payer {
            returnedPayer = payer
        }
        return returnedPayer
    }

    public func getPaymentMethod() -> PXPaymentMethod? {
        return paymentMethod
    }

    func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }

    func toJSON() -> [String: Any] {
        return [:]
    }

    public func setDiscount(_ discount: PXDiscount, withCampaign campaign: PXCampaign) {
        self.discount = discount
        self.campaign = campaign
    }

    public func clearDiscount() {
        self.discount = nil
        self.campaign = nil
    }

}
