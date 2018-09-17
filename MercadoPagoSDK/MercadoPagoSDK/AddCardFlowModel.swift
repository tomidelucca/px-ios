//
//  AddCardFlowModel.swift
//  MercadoPagoSDK
//
//  Created by Diego Flores Domenech on 6/9/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

class AddCardFlowModel: NSObject, PXFlowModel {
    
    var paymentMethods: [PaymentMethod]?
    var cardToken: CardToken?
    var selectedPaymentMethod: PaymentMethod?
    var tokenizedCard: Token?

    enum Steps {
        case start
        case getPaymentMethods
        case openCardForm
        case createToken
        case associateTokenWithUser
        case finish
    }
    
    private var currentStep = Steps.start
    
    func nextStep() -> AddCardFlowModel.Steps {
        switch currentStep {
        case .start:
            currentStep = .getPaymentMethods
        case .getPaymentMethods:
            currentStep = .openCardForm
        case .openCardForm:
            currentStep = .createToken
        case .createToken:
            currentStep = .associateTokenWithUser
        case .associateTokenWithUser:
            currentStep = .finish
        }
        return currentStep
    }
    
}
