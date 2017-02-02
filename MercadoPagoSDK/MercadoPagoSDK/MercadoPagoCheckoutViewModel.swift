//
//  CheckoutViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/23/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public enum CheckoutStep : String {
    case SEARCH_PAYMENT_METHODS
    case PAYMENT_METHOD
    case PM_OFF
    case CARD_FORM
    case SECURITY_CODE_ONLY
    case CREDIT_DEBIT
    case ISSUER
    case IDENTIFICATION
    case PAYER_COST
    case REVIEW_AND_CONFIRM
    case POST_PAYMENT
    case CONGRATS
    case FINISH
    case ERROR
}



open class MercadoPagoCheckoutViewModel: NSObject {

    let amount : Double = 1000
    var paymentMethods : [PaymentMethod]?
    var cardToken: CardToken?
    var payerCost: PayerCost?
    var paymentOptionSelected : PaymentMethodOption?
    
    var customerId : String?
    
    //optional?
    var paymentMethodOptions : [PaymentMethodOption]?
    //distinto a la lista anterior
    var availablePaymentMethods : [PaymentMethod]?
    
    // flowpreference

    
    //--- PAYMENT DATA
    
    var selectedPaymentMethod : PaymentMethod?
    var selectedIssuer : Issuer?
    var selectedPayerCost : PayerCost?
    var selectedToken : Token?
    //----------------
    
    
    var next : CheckoutStep = .SEARCH_PAYMENT_METHODS
    
    
    
    
    public func getPaymentPreferences() -> PaymentPreference? {
        return nil
    }
    
    public func cardFormManager() -> CardViewModelManager{
        return CardViewModelManager(amount : amount, paymentMethods :nil, paymentSettings : nil)
    }
    
    public func debitCreditViewModel() -> CardAdditionalStepViewModel{
        var pms : [PaymentMethod] = []
        if let _ = paymentMethods {
            pms = paymentMethods!
        }
        return CardAdditionalStepViewModel(paymentMethods: pms, issuer: nil, token: nil, amount: nil, paymentPreference: nil, installment: nil, callback: nil)
    }
    
    func paymentVaultViewModel() -> PaymentVaultViewModel {
        // TODO : Customer payment methods! + yerbas
        return PaymentVaultViewModel(amount: self.amount, paymentPrefence: getPaymentPreferences(), paymentMethodOptions: self.paymentMethodOptions!)
    }
    
    public func issuerViewModel() -> CardAdditionalStepViewModel{
        var pms : [PaymentMethod] = []
        if let pm = selectedPaymentMethod {
            pms = [pm]
        }
        return CardAdditionalStepViewModel(paymentMethods: pms, issuer: nil, token: cardToken, amount: nil, paymentPreference: nil, installment: nil, callback: nil)
    }
    
    public func payerCostViewModel() -> CardAdditionalStepViewModel{
        var pms : [PaymentMethod] = []
        if let pm = selectedPaymentMethod {
            pms = [pm]
        }
        return CardAdditionalStepViewModel(paymentMethods: pms, issuer: selectedIssuer, token: cardToken, amount: amount, paymentPreference: getPaymentPreferences(), installment: nil, callback: nil)
    }
    
    public func securityCodeViewModel() -> SecrurityCodeViewModel {
        let cardInformation = self.paymentOptionSelected as! CardInformation
        return SecrurityCodeViewModel(paymentMethod: selectedPaymentMethod, cardInfo: cardInformation)
    }
    
    public func updateCheckoutModel(paymentMethods: [PaymentMethod], cardToken: CardToken?){
        self.paymentMethods = paymentMethods
        self.selectedPaymentMethod = self.paymentMethods?[0] // Ver si son mas de uno
        self.cardToken = cardToken
        self.next = CheckoutStep.ISSUER
    }
    
    public func updateCheckoutModel(paymentMethod: PaymentMethod?){
        self.selectedPaymentMethod = paymentMethod
    }
    
    public func updateCheckoutModel(issuer: Issuer?){
        self.selectedIssuer = issuer
        self.next = CheckoutStep.PAYER_COST
    }
    public func updateCheckoutModel(payerCost: PayerCost?){
        self.selectedPayerCost = payerCost
        self.next = CheckoutStep.FINISH
    }
    
    public func updateCheckoutModel(paymentMethodSelected : PaymentMethodOption){
        self.paymentOptionSelected = paymentMethodSelected
        if (self.paymentOptionSelected!.hasChildren()) {
            self.paymentMethodOptions = self.paymentOptionSelected!.getChildren()
            self.next = .PAYMENT_METHOD
        } else if (self.paymentOptionSelected!.isCustomerPaymentMethod()){
            self.selectedPaymentMethod = (self.paymentOptionSelected as! CardInformation).getPaymentMethod()
            self.next = .SECURITY_CODE_ONLY
        } else {
            self.selectedPaymentMethod = Utils.findPaymentMethod(self.availablePaymentMethods!, paymentMethodId: paymentMethodSelected.getId())
            if (self.paymentOptionSelected!.isCard()) {
                self.next = .CARD_FORM
            } else {
                self.next = .REVIEW_AND_CONFIRM
            }
        }
    }
    

    public func nextStep() -> CheckoutStep {

        // MPError != NULL -> *** ERROR ***
        
        // Si no tengo PT seleccionado
            // Si no tengo PMs -> *** Buscar : PMs SEARCH_PAYMENT_METHODS ***
            // Si tengo PMs -> *** PAYMENT_METHOD *** ( Si ya tengo subseleccion entro con subseleccion, sino con todos los PMs)
        // Si tengo PT seleccionado
                //Si es tarjeta de credito
                    //Si no tengo cardtoken -> *** Pido que complete los datos de tarjeta : CARD_FORM ***
                    //Si no tengo issuer seleccionado -> *** Pido carga del Issuer : ISSUER ***
                    //Si no tengo identification seleccionada y es requerida -> *** Pido carga del Identification : IDENTIFICATION ***
                    //Si no tengo cuota seleccionada -> *** Pido carga del PayerCost : PAYER_COST ***
            // *** Muestro Revisa y confirma : REVIEW_AND_CONFIRM ***
        
        
        return next
    }
    
    public func updateCheckoutModel(paymentMethodOptions : [PaymentMethodOption], availablePaymentMethods : [PaymentMethod]) {
        self.paymentMethodOptions = paymentMethodOptions
        self.availablePaymentMethods = availablePaymentMethods
        self.next = .PAYMENT_METHOD
    }
    
    public func updateCheckoutModel(token : Token) {
        self.selectedToken = token
        self.next = .PAYER_COST
    }
    
    public func updateCheckoutModel(paymentMethodOptions : [PaymentMethodOption]) {
        if self.paymentMethodOptions != nil {
            self.paymentMethodOptions!.insert(contentsOf: paymentMethodOptions, at: 0)
        } else {
            self.paymentMethodOptions = paymentMethodOptions
        }
        self.next = .PAYMENT_METHOD
    }

}

