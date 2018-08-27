//
//  CustomerPaymentMethod.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 4/8/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoServicesV4

@objcMembers internal class CustomerPaymentMethod: NSObject, CardInformation, PaymentMethodOption {

    var customerPaymentMethodId: String!
    var customerPaymentMethodDescription: String!
    var paymentMethodId: String!
    var paymentMethodTypeId: String!
    var firstSixDigits: String!

    var securityCode: PXSecurityCode?
    var paymentMethod: PXPaymentMethod?
    var card: Card?

    internal class func fromJSON(_ json: NSDictionary) -> CustomerPaymentMethod {
                let customerPaymentMethod = CustomerPaymentMethod()

                if json["id"] != nil && !(json["id"]! is NSNull) {
                       if let cPaymentMethodId = json["id"] as? String {
                                customerPaymentMethod.customerPaymentMethodId = cPaymentMethodId
                            }
                    }

                if json["description"] != nil && !(json["description"]! is NSNull) {
                        if let cPaymentMethodDesc = json["description"] as? String {
                                customerPaymentMethod.customerPaymentMethodDescription = cPaymentMethodDesc
                            }
                   }

                if json["payment_method_id"] != nil && !(json["payment_method_id"]! is NSNull) {
                        if let paymentMethodId = json["payment_method_id"] as? String {
                                customerPaymentMethod.paymentMethodId = paymentMethodId
                            }
                    }

                if json["payment_method_type"] != nil && !(json["payment_method_type"]! is NSNull) {
                        if let cPaymentMethodTypeId = json["payment_method_type"] as? String {
                                customerPaymentMethod.paymentMethodTypeId = cPaymentMethodTypeId
                            }
                    }

                if json["first_six_digits"] != nil && !(json["first_six_digits"]! is NSNull) {
                        if let cFirstSixDigits = json["first_six_digits"] as? String {
                                customerPaymentMethod.firstSixDigits = cFirstSixDigits
                            }
                    }

                return customerPaymentMethod
            }

    public override init() {
        super.init()
    }

    init(cPaymentMethodId: String, paymentMethodId: String, paymentMethodTypeId: String, description: String) {
        self.customerPaymentMethodId = cPaymentMethodId
        self.paymentMethodId = paymentMethodId
        self.paymentMethodTypeId = paymentMethodTypeId
        self.customerPaymentMethodDescription = description
    }

    func getIssuer() -> PXIssuer? {
        return card?.issuer
    }

    internal func toJSON() -> [String: Any] {
        let obj: [String: Any] = [
            "_id": self.customerPaymentMethodId,
            "_description": self.customerPaymentMethodDescription == nil ? "" : self.customerPaymentMethodDescription!,
            "payment_method_id": self.paymentMethodId,
            "payment_method_type": self.paymentMethodTypeId
        ]

        return obj
    }

    func getFirstSixDigits() -> String? {
        return card?.getCardBin()
    }

    func toJSONString() -> String {
        return JSONHandler.jsonCoding(self.toJSON())
    }

    func isSecurityCodeRequired() -> Bool {
        return true
    }

    func getCardId() -> String {
        return self.customerPaymentMethodId
    }

    func getCardSecurityCode() -> PXSecurityCode? {
        return securityCode
    }

    func getCardDescription() -> String {
        return self.customerPaymentMethodDescription
    }

    func getPaymentMethod() -> PXPaymentMethod? {
        return paymentMethod
    }

    func getPaymentMethodId() -> String {
        return self.paymentMethodId
    }

    func getPaymentTypeId() -> String {
        return self.paymentMethodTypeId
    }

    func getCardBin() -> String? {
        return card?.getCardBin()
    }

    func getCardLastForDigits() -> String? {
        return card?.getCardLastForDigits()
    }

    func setupPaymentMethod(_ paymentMethod: PXPaymentMethod) {
        self.paymentMethod = paymentMethod
    }

    func setupPaymentMethodSettings(_ settings: [PXSetting]) {
        self.securityCode = settings[0].securityCode
    }

    func isIssuerRequired() -> Bool {
        return false
    }

    /** PaymentOptionDrawable implementation */

    func getTitle() -> String {
        return getCardDescription()
    }

    func getSubtitle() -> String? {
        return nil
    }

    func getImage() -> UIImage? {
        return ResourceManager.shared.getImageForPaymentMethod(withDescription: self.getPaymentMethodId())
    }

    /** PaymentMethodOption  implementation */

    func hasChildren() -> Bool {
        return false
    }

    func getChildren() -> [PaymentMethodOption]? {
        return nil
    }

    func getId() -> String {
        return self.customerPaymentMethodId
    }

    func isCustomerPaymentMethod() -> Bool {
        return true
    }

    func isCard() -> Bool {

        return PXPaymentTypes.isCard(paymentTypeId: self.paymentMethodTypeId)
    }

    func getDescription() -> String {
        return self.customerPaymentMethodDescription
    }

    func getComment() -> String {
        return ""
    }

    func canBeClone() -> Bool {
        return false
    }
}
