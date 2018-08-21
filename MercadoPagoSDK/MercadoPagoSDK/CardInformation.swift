//
//  CardInformation.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/8/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoServicesV4

/** :nodoc: */
@objc
public protocol CardInformation: CardInformationForm, PaymentOptionDrawable {

    func isSecurityCodeRequired() -> Bool

    func getCardId() -> String

    func getCardSecurityCode() -> PXSecurityCode?

    func getCardDescription() -> String

    func setupPaymentMethodSettings(_ settings: [PXSetting])

    func setupPaymentMethod(_ paymentMethod: PXPaymentMethod)

    func getPaymentMethod() -> PXPaymentMethod?

    func getPaymentMethodId() -> String

    func getPaymentTypeId() -> String

    func getIssuer() -> PXIssuer?

    func getFirstSixDigits() -> String!

}

/** :nodoc: */
@objc
public protocol CardInformationForm: NSObjectProtocol {

    func getCardBin() -> String?

    func getCardLastForDigits() -> String?

    func isIssuerRequired() -> Bool

    func canBeClone() -> Bool
}
