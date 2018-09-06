//
//  PXCard+Business.swift
//  MercadoPagoSDKV4
//
//  Created by Eden Torres on 03/09/2018.
//

import Foundation
internal extension PXCard {
    func isSecurityCodeRequired() -> Bool {
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

    func getFirstSixDigits() -> String! {
        return firstSixDigits
    }
    func getCardDescription() -> String {
        return "terminada en " + lastFourDigits! //TODO: Make it localizable
    }

    func getPaymentMethod() -> PXPaymentMethod? {
        return self.paymentMethod
    }

    func getCardId() -> String {
        return id ?? ""
    }

    func getPaymentMethodId() -> String {
        return self.paymentMethod?.id ?? ""
    }

    func getPaymentTypeId() -> String {
        return self.paymentMethod?.paymentTypeId ?? ""
    }

    func getCardSecurityCode() -> PXSecurityCode {
        return self.securityCode!
    }

    func getCardBin() -> String? {
        return self.firstSixDigits
    }

    func getCardLastForDigits() -> String? {
        return self.lastFourDigits
    }

    func setupPaymentMethodSettings(_ settings: [PXSetting]) {
        self.paymentMethod?.settings = settings
    }

    func setupPaymentMethod(_ paymentMethod: PXPaymentMethod) {
        self.paymentMethod = paymentMethod
    }

    func isIssuerRequired() -> Bool {
        return self.issuer == nil
    }

    func canBeClone() -> Bool {
        return false
    }

}

extension PXCard: PaymentOptionDrawable {

    func getTitle() -> String {
        return getCardDescription()
    }

    func getSubtitle() -> String? {
        return nil
    }

    func getImage() -> UIImage? {
        return ResourceManager.shared.getImageForPaymentMethod(withDescription: self.getPaymentMethodId())
    }
}

extension PXCard: PaymentMethodOption {

    func getId() -> String {
        return String(describing: id)
    }

    func getChildren() -> [PaymentMethodOption]? {
        return nil
    }

    func hasChildren() -> Bool {
        return false
    }

    func isCard() -> Bool {
        return true
    }

    func isCustomerPaymentMethod() -> Bool {
        return true
    }

    func getDescription() -> String {
        return ""
    }

    func getComment() -> String {
        return ""
    }
}
