//
//  MercadoPagoCheckoutViewModel+MonneyIn.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 2/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

// MARK: - Only for MonneyIn Flow
extension MercadoPagoCheckoutViewModel {

    func getPreferenceDefaultPaymentOption() -> PaymentMethodOption? {

        guard let cardId = amountHelper.preference.paymentPreference.defaultPaymentMethodId else {
            return nil
        }

        if let search = self.search {
            guard let customerPaymentMethods = search.customerPaymentMethods else {
                return nil
            }
            let customOptionsFound = customerPaymentMethods.filter { (cardInformation: CardInformation) -> Bool in
                return cardInformation.getCardId() == cardId
            }
            if let customerPaymentMethod = customOptionsFound.first, let customerPaymentOption = customerPaymentMethod as? PaymentMethodOption {
                return customerPaymentOption
            }
        }

        if let options = self.paymentMethodOptions {
            let optionsFound = options.filter { (paymentMethodOption: PaymentMethodOption) -> Bool in
                return paymentMethodOption.getId() == cardId
            }
            if let paymentOption = optionsFound.first {
                return paymentOption
            }
        }
        return nil
    }
}
