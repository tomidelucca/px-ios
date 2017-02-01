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

    var checkoutPreference : CheckoutPreference!
    
    var paymentMethods : [PaymentMethod]?
    // card token previo a la tokenización y válido para pago
    var cardToken: CardToken?
//    var payerCost: PayerCost?
//    
    
    var customerId : String?
    
    //optionals?
    // Payment methods disponibles en selección de medio de pago
    var paymentMethodOptions : [PaymentMethodOption]?
    // Payment method seleccionado en selección de medio de pago
    var paymentOptionSelected : PaymentMethodOption?
    // Payment method disponibles correspondientes a las opciones que se muestran en selección de medio de pago
    var availablePaymentMethods : [PaymentMethod]?
    
    
    // flowpreference
    //
    //
    //
    //
    //
    
    
    //--- PAYMENT DATA
    var paymentData = PaymentData()

    //----------------
    
    var payment : Payment?
    
    var next : CheckoutStep = .SEARCH_PAYMENT_METHODS
    
    init(checkoutPreference : CheckoutPreference){
        self.checkoutPreference = checkoutPreference
    }
    
    
    public func getPaymentPreferences() -> PaymentPreference? {
        return nil
    }
    
    public func cardFormManager() -> CardViewModelManager{
        return CardViewModelManager(amount : self.getAmount(), paymentMethods :nil, paymentSettings : nil)
    }
    
    public func debitCreditViewModel() -> CardAdditionalStepViewModel{
        var pms : [PaymentMethod] = []
        if let _ = paymentMethods {
            pms = paymentMethods!
        }
        return CardAdditionalStepViewModel(paymentMethods: pms, issuer: nil, token: nil, amount: self.getAmount(), paymentPreference: nil, installment: nil, callback: nil)
    }
    
    func paymentVaultViewModel() -> PaymentVaultViewModel {
        // TODO : Customer payment methods! + yerbas
        return PaymentVaultViewModel(amount: self.getAmount(), paymentPrefence: getPaymentPreferences(), paymentMethodOptions: self.paymentMethodOptions!)
    }
    
    public func issuerViewModel() -> CardAdditionalStepViewModel{
        var pms : [PaymentMethod] = []
        if let pm = self.paymentData.paymentMethod {
            pms = [pm]
        }
        return CardAdditionalStepViewModel(paymentMethods: pms, issuer: nil, token: self.cardToken, amount: self.getAmount(), paymentPreference: nil, installment: nil, callback: nil)
    }
    
    public func payerCostViewModel() -> CardAdditionalStepViewModel{
        var pms : [PaymentMethod] = []
        if let pm = self.paymentData.paymentMethod {
            pms = [pm]
        }
        return CardAdditionalStepViewModel(paymentMethods: pms, issuer: self.paymentData.issuer, token: self.cardToken, amount: self.getAmount(), paymentPreference: getPaymentPreferences(), installment: nil, callback: nil)
    }
    
    public func securityCodeViewModel() -> SecrurityCodeViewModel {
        let cardInformation = self.paymentOptionSelected as! CardInformation
        return SecrurityCodeViewModel(paymentMethod: self.paymentData.paymentMethod!, cardInfo: cardInformation)
    }
    
    public func checkoutViewModel() -> CheckoutViewModel {
        let checkoutViewModel = CheckoutViewModel(checkoutPreference: self.checkoutPreference, paymentData : self.paymentData, paymentOptionSelected : self.paymentOptionSelected!)
        return checkoutViewModel
    }
    
    public func updateCheckoutModel(paymentMethods: [PaymentMethod], cardToken: CardToken?){
        self.paymentMethods = paymentMethods
        self.paymentData.paymentMethod = self.paymentMethods?[0] // Ver si son mas de uno
        self.cardToken = cardToken
        self.next = CheckoutStep.ISSUER
    }
    
    public func updateCheckoutModel(paymentMethod: PaymentMethod?){
        self.paymentData.paymentMethod = paymentMethod
    }
    
    public func updateCheckoutModel(issuer: Issuer?){
        self.paymentData.issuer = issuer
        self.next = CheckoutStep.PAYER_COST
    }
    public func updateCheckoutModel(payerCost: PayerCost?){
        self.paymentData.payerCost = payerCost
        self.next = CheckoutStep.FINISH
    }
    
    public func updateCheckoutModel(paymentMethodSelected : PaymentMethodOption){
        self.paymentOptionSelected = paymentMethodSelected
        if (self.paymentOptionSelected!.hasChildren()) {
            self.paymentMethodOptions = self.paymentOptionSelected!.getChildren()
            self.next = .PAYMENT_METHOD
        } else if (self.paymentOptionSelected!.isCustomerPaymentMethod()){
            self.paymentData.paymentMethod = (self.paymentOptionSelected as! CardInformation).getPaymentMethod()
            self.next = .SECURITY_CODE_ONLY
        } else {
            self.paymentData.paymentMethod = Utils.findPaymentMethod(self.availablePaymentMethods!, paymentMethodId: paymentMethodSelected.getId())
            if (self.paymentOptionSelected!.isCard()) {
                self.next = .CARD_FORM
            } else {
                self.next = .REVIEW_AND_CONFIRM
            }
        }
    }
    
    public func nextStep() -> CheckoutStep {
        // --  --
        return next
    }
    
    public func updateCheckoutModel(paymentMethodOptions : [PaymentMethodOption], availablePaymentMethods : [PaymentMethod]) {
        self.paymentMethodOptions = paymentMethodOptions
        self.availablePaymentMethods = availablePaymentMethods
        self.next = .PAYMENT_METHOD
    }
    
    public func updateCheckoutModel(token : Token) {
        self.paymentData.token = token
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
    
    // PARAM QUIZAS NO NECESARIO
    func updateCheckoutModel(paymentData: PaymentData){
        self.next = .POST_PAYMENT
        self.createPayment()
    }
    
    public func updateCheckoutModel(payment : Payment) {
        self.payment = payment
        self.next = .CONGRATS
    }
    
    internal func getAmount() -> Double {
        return self.checkoutPreference.getAmount()
    }
   
    func createPayment() {
        print("POSTEO DE PAGO =D")
        //TODO : llamar ServicePreference
    }
    
}

