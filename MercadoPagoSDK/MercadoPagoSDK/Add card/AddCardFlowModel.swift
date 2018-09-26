//
//  AddCardFlowModel.swift
//  MercadoPagoSDK
//
//  Created by Diego Flores Domenech on 6/9/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

class AddCardFlowModel: NSObject, PXFlowModel {
    
    var paymentMethods: [PXPaymentMethod]?
    var cardToken: PXCardToken?
    var selectedPaymentMethod: PXPaymentMethod?
    var tokenizedCard: PXToken?
    var lastStepFailed = false

    enum Steps {
        case start
        case getPaymentMethods
        case openCardForm
        case createToken
        case associateTokenWithUser
        case showCongrats
        case finish
    }
    
    private var currentStep = Steps.start
    
    func nextStep() -> AddCardFlowModel.Steps {
        if lastStepFailed {
            lastStepFailed = false
            return currentStep
        }
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
            currentStep = .showCongrats
        case .showCongrats:
            currentStep = .finish
        default:
            break
        }
        return currentStep
    }
    
    func reset() {
        self.currentStep = .openCardForm
    }
    
}
