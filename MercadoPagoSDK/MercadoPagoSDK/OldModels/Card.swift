//
//  Card.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit
import MercadoPagoServicesV4

/** :nodoc: */
@objcMembers open class Card: NSObject, CardInformation, PaymentMethodOption {

    open var cardHolder: PXCardHolder?
    open var customerId: String?
    open var dateCreated: Date?
    open var dateLastUpdated: Date?
    open var expirationMonth: Int = 0
    open var expirationYear: Int = 0
    open var firstSixDigits: String?
    open var idCard: String = ""
    open var lastFourDigits: String?
    open var paymentMethod: PXPaymentMethod?
    open var issuer: PXIssuer?
    open var securityCode: PXSecurityCode?

    internal class func fromJSON(_ json: NSDictionary) -> Card {
                let card: Card = Card()
                if let customerId = JSONHandler.attemptParseToString(json["customer_id"]) {
                        card.customerId = customerId
                    }
                if let expirationMonth = JSONHandler.attemptParseToInt(json["expiration_month"]) {
                        card.expirationMonth = expirationMonth
                    }
                if let expirationYear = JSONHandler.attemptParseToInt(json["expiration_year"]) {
                        card.expirationYear = expirationYear
                    }
                card.idCard = JSONHandler.attemptParseToString(json["id"], defaultReturn: "")!
                if let lastFourDigits = JSONHandler.attemptParseToString(json["last_four_digits"]) {
                        card.lastFourDigits = lastFourDigits
                   }
                if let firstSixDigits = JSONHandler.attemptParseToString(json["first_six_digits"]) {
                        card.firstSixDigits = firstSixDigits
                    }

               if let dateLastUpdated = JSONHandler.attemptParseToString(json["date_last_updated"]) {
                        card.dateLastUpdated = Utils.getDateFromString(dateLastUpdated)
                    }
                if let dateCreated = JSONHandler.attemptParseToString(json["date_created"]) {
                        card.dateCreated = Utils.getDateFromString(dateCreated)
                    }
                return card
            }

    public func getIssuer() -> PXIssuer? {
        return self.issuer
    }

    internal func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }

    internal func toJSON() -> [String: Any] {
        let customer_id: Any = self.customerId == nil ? JSONHandler.null : self.customerId!
        let dateCreated: Any = self.dateCreated == nil ? JSONHandler.null : String(describing: self.dateCreated!)
        let dateLastUpdated: Any = self.dateLastUpdated == nil ? JSONHandler.null : String(describing: self.dateLastUpdated!)
        let firstSixDigits: Any = self.firstSixDigits == nil ? JSONHandler.null : self.firstSixDigits!
        let lastFourDigits: Any = self.lastFourDigits == nil ? JSONHandler.null : self.lastFourDigits!
        let obj: [String: Any] = [
            "card_holder": cardHolder,
            "customer_id": customer_id,
            "date_created": dateCreated,
            "date_last_updated": dateLastUpdated,
            "expiration_month": self.expirationMonth,
            "expiration_year": self.expirationYear,
            "first_six_digits": firstSixDigits,
            "id": self.idCard,
            "last_four_digits": lastFourDigits,
            "payment_method": paymentMethod,
            "security_code": securityCode
        ]
        return obj
    }

    open func isSecurityCodeRequired() -> Bool {
        if securityCode != nil {
            if securityCode!.length != 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    public func getFirstSixDigits() -> String! {
        return firstSixDigits
    }
    open func getCardDescription() -> String {
        return "terminada en " + lastFourDigits! //TODO: Make it localizable
    }

    open func getPaymentMethod() -> PXPaymentMethod? {
        return self.paymentMethod
    }

    open func getCardId() -> String {
        return self.idCard
    }

    open func getPaymentMethodId() -> String {
        return (self.paymentMethod?.paymentMethodId)!
    }

    open func getPaymentTypeId() -> String {
        return self.paymentMethod?.paymentTypeId ?? ""
    }

    open func getCardSecurityCode() -> PXSecurityCode {
        return self.securityCode!
    }

    open func getCardBin() -> String? {
        return self.firstSixDigits
    }

    open func getCardLastForDigits() -> String? {
        return self.lastFourDigits!
    }

    open func setupPaymentMethodSettings(_ settings: [PXSetting]) {
        self.paymentMethod?.settings = settings
    }

    open func setupPaymentMethod(_ paymentMethod: PXPaymentMethod) {
        self.paymentMethod = paymentMethod
    }

    public func isIssuerRequired() -> Bool {
        return self.issuer == nil
    }

    public func canBeClone() -> Bool {
        return false
    }

    /** PaymentOptionDrawable implementation */

    public func getTitle() -> String {
        return getCardDescription()
    }

    public func getSubtitle() -> String? {
        return nil
    }

    public func getImage() -> UIImage? {
        return ResourceManager.shared.getImageForPaymentMethod(withDescription: self.getPaymentMethodId())
    }

    /** PaymentMethodOption implementation */

    public func getId() -> String {
        return String(describing: self.idCard)
    }

    func getChildren() -> [PaymentMethodOption]? {
        return nil
    }

    public func hasChildren() -> Bool {
        return false
    }

    public func isCard() -> Bool {
        return true
    }

    public func isCustomerPaymentMethod() -> Bool {
        return true
    }

    public func getDescription() -> String {
        return ""
    }

    public func getComment() -> String {
        return ""
    }
}
