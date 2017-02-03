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
    case SEARCH_CUSTOMER_PAYMENT_METHODS
    case PAYMENT_METHOD_SELECTION
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
    
    var rootPaymentMethodOptions : [PaymentMethodOption]?
    
    var customPaymentOptions : [CardInformation]?
    
    var rootVC = true
    
    // flowpreference

    var paymentData = PaymentData()

    //----------------
    
    var payment : Payment?
    
    var next : CheckoutStep = .SEARCH_PAYMENT_METHODS
    
    
    
    var error : MPSDKError?
    var identification : Identification?
    
    
    
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
        return PaymentVaultViewModel(amount: self.getAmount(), paymentPrefence: getPaymentPreferences(), paymentMethodOptions: self.paymentMethodOptions!, customerPaymentOptions: self.customPaymentOptions, isRoot : rootVC)
    }
    
    public func issuerViewModel() -> CardAdditionalStepViewModel{
        var pms : [PaymentMethod] = []
        if let pm = self.paymentData.paymentMethod {
            pms = [pm]
        }
        return CardAdditionalStepViewModel(paymentMethods: pms, issuer: nil, token: self.cardToken, amount: self.getAmount(), paymentPreference: nil, installment: nil, callback: nil)
    }
    
    public func payerCostViewModel() -> CardAdditionalStepViewModel{
        let cardInformation = self.paymentOptionSelected as? CardInformation ?? nil
        var pms : [PaymentMethod] = []
        if let pm = self.paymentData.paymentMethod {
            pms = [pm]
        }
        return CardAdditionalStepViewModel(cardInformation : cardInformation, paymentMethods: pms, issuer: self.paymentData.issuer, token: self.cardToken, amount: self.getAmount(), paymentPreference: getPaymentPreferences(), installment: nil, callback: nil)
    }
    
    public func securityCodeViewModel() -> SecrurityCodeViewModel {
        let cardInformation = self.paymentOptionSelected as! CardInformation
        return SecrurityCodeViewModel(paymentMethod: self.paymentData.paymentMethod!, cardInfo: cardInformation)
    }
    
    public func checkoutViewModel() -> CheckoutViewModel {
        let checkoutViewModel = CheckoutViewModel(checkoutPreference: self.checkoutPreference, paymentData : self.paymentData, paymentOptionSelected : self.paymentOptionSelected!)
        return checkoutViewModel
    }
    
    //SEARCH_PAYMENT_METHODS
    public func updateCheckoutModel(paymentMethods: [PaymentMethod], cardToken: CardToken?){
        self.paymentMethods = paymentMethods
        self.paymentData.paymentMethod = self.paymentMethods?[0] // Ver si son mas de uno
        self.cardToken = cardToken
        self.next = CheckoutStep.ISSUER
    }
    
    //CREDIT_DEBIT
    public func updateCheckoutModel(paymentMethod: PaymentMethod?){
        self.paymentData.paymentMethod = paymentMethod
    }
    
    public func updateCheckoutModel(issuer: Issuer?){
        self.paymentData.issuer = issuer
        self.next = CheckoutStep.PAYER_COST
    }
    public func updateCheckoutModel(payerCost: PayerCost?){
        self.paymentData.payerCost = payerCost
        self.next = CheckoutStep.REVIEW_AND_CONFIRM
    }
    
    //PAYMENT_METHOD_SELECTION
    public func updateCheckoutModel(paymentOptionSelected : PaymentMethodOption){
        self.paymentOptionSelected = paymentOptionSelected
        if let childrenOptions = paymentOptionSelected.getChildren() {
            self.paymentMethodOptions =  childrenOptions
        }
        if (self.paymentOptionSelected!.isCustomerPaymentMethod()){
            self.findAndCompletePaymentMethodFor(paymentMethodId: paymentOptionSelected.getId())
        }
       // } else {
       //     if (self.paymentOptionSelected!.isCard()) {
       //         self.next = .CARD_FORM
       //     } else {
       //         self.paymentData.paymentMethod = Utils.findPaymentMethod(self.availablePaymentMethods!, paymentMethodId: paymentOptionSelected.getId())
      //          self.next = .REVIEW_AND_CONFIRM
       //     }
       // }
    }
    

    public func nextStep() -> CheckoutStep {

        if hasError() {
            return .ERROR
        }
        
        if needSearch() {
            return .SEARCH_PAYMENT_METHODS
        }
        
        if !arePaymentTypeSelected(){
            return .PAYMENT_METHOD_SELECTION
        }
        if needSecurityCode(){
            return .SECURITY_CODE_ONLY
        }
        if needCompleteCard() {
            return .CARD_FORM
        }
        
        if needGetIssuer() {
            return .ISSUER
        }
        
        if needGetIdentification() {
       //     return .IDENTIFICATION
        }
        
        if needChosePayerCost() {
            return .PAYER_COST
        }
        
        return .REVIEW_AND_CONFIRM
                //Si es un metodo custom
                    //Si no tengo cuota seleccionada -> *** Pido carga del PayerCost : PAYER_COST ***
                    //Si no tengo token -> *** Pido carga del CVV : SECURITY_CODE_ONLY ***


    }
    
    func hasError() -> Bool{
        return error != nil
    }
    
    func needSearch() -> Bool {
        return search == nil
    }
    func arePaymentTypeSelected() -> Bool {
        guard let selectedType = self.paymentOptionSelected else {
            return false
        }
        return !selectedType.hasChildren()
    }
    func needCompleteCard() -> Bool {
        guard let selectedType = self.paymentOptionSelected else {
            return false
        }
        if !selectedType.isCard() {
            return false
        }
        return self.cardToken == nil && !selectedType.isCustomerPaymentMethod()
    }
    
    func showConfirm() -> Bool {
        return self.paymentData.complete()
    }
    
    func showCongrats() -> Bool {
        return self.payment != nil
    }
    func needGetIdentification() -> Bool {
        guard let pm = self.paymentData.paymentMethod , let option = self.paymentOptionSelected else {
            return false
        }
        if identification == nil && pm.isIdentificationRequired() && !option.isCustomerPaymentMethod(){
            return true
        }else{
            return false
        }
    }
    func needGetIssuer() -> Bool {
        guard let pm = self.paymentData.paymentMethod else {
            return false
        }
        if paymentData.issuer == nil && pm.isIssuerRequired() {
            return true
        }
        return false
    }
    func needChosePayerCost() -> Bool {
        guard let pm = self.paymentData.paymentMethod else {
            return false
        }
        if pm.isCreditCard() && self.paymentData.payerCost == nil {
            return true
        }else{
            return false
        }
    }
    func needSecurityCode() -> Bool {
        guard let pmSelected = self.paymentOptionSelected else {
            return false
        }
        if pmSelected.isCustomerPaymentMethod() && self.paymentData.token == nil {
            return true
        }
        return false
    }
    
    var search : PaymentMethodSearch?
    
    public func updateCheckoutModel(paymentMethodSearch : PaymentMethodSearch) {
        self.search = paymentMethodSearch
        if !Array.isNullOrEmpty(paymentMethodSearch.customerPaymentMethods) {
            self.customPaymentOptions = paymentMethodSearch.customerPaymentMethods
        }
        // La primera vez las opciones a mostrar van a ser el root de grupos
        self.rootPaymentMethodOptions = paymentMethodSearch.groups
        self.paymentMethodOptions = self.rootPaymentMethodOptions
        self.availablePaymentMethods = paymentMethodSearch.paymentMethods
        self.next = .PAYMENT_METHOD_SELECTION
    }
    
    
    public func updateCheckoutModel(token : Token) {
        self.paymentData.token = token
        self.next = .PAYER_COST
    }

    open class func createMPPayment(_ email : String, preferenceId : String, paymentMethod: PaymentMethod, token : Token? = nil, installments: Int = 1, issuer: Issuer? = nil, customerId : String? = nil) -> MPPayment {
        
        var issuerId = ""
        if issuer != nil {
            issuerId = String(issuer!._id!.intValue)
        }
        var tokenId = ""
        if token != nil {
            tokenId = token!._id
        }
        
        let isBlacklabelPayment = token != nil && token?.cardId != nil && String.isNullOrEmpty(customerId)
        
        let mpPayment = MPPaymentFactory.createMPPayment(email: email, preferenceId: preferenceId, publicKey: MercadoPagoContext.publicKey(), paymentMethodId: paymentMethod._id, installments: installments, issuerId: issuerId, tokenId: tokenId, customerId: customerId, isBlacklabelPayment: isBlacklabelPayment)
        return mpPayment
    }
    
    
    public func updateCheckoutModel(paymentMethodOptions : [PaymentMethodOption]) {
        if self.rootPaymentMethodOptions != nil {
            self.rootPaymentMethodOptions!.insert(contentsOf: paymentMethodOptions, at: 0)
        } else {
            self.rootPaymentMethodOptions = paymentMethodOptions
        }
        self.paymentMethodOptions = self.rootPaymentMethodOptions
        self.next = .PAYMENT_METHOD_SELECTION
    }
    
    func updateCheckoutModel(paymentData: PaymentData){
        if paymentData.paymentMethod == nil {
            // Vuelvo a root para iniciar la selección de medios de pago
            self.paymentMethodOptions = self.rootPaymentMethodOptions!
            self.rootVC = true
            self.next = .SEARCH_PAYMENT_METHODS
        } else {
            self.next = .POST_PAYMENT
        }
    }
    
    public func updateCheckoutModel(payment : Payment) {
        self.payment = payment
        self.next = .CONGRATS
    }

    
    internal func getAmount() -> Double {
        return self.checkoutPreference.getAmount()
    }
    
    
    internal func findAndCompletePaymentMethodFor(paymentMethodId : String){
        if paymentMethodId == PaymentTypeId.ACCOUNT_MONEY.rawValue {
            self.paymentData.paymentMethod = Utils.findPaymentMethod(self.availablePaymentMethods!, paymentMethodId: paymentMethodId)
        }else{
            let cardInformation = (self.paymentOptionSelected as! CardInformation)
            let paymentMethod = Utils.findPaymentMethod(self.availablePaymentMethods!, paymentMethodId:paymentMethodId)
            cardInformation.setupPaymentMethodSettings(paymentMethod.settings)
            cardInformation.setupPaymentMethod(paymentMethod)
            self.paymentData.paymentMethod = cardInformation.getPaymentMethod()
        }
        
    }
    internal func handleCustomerPaymentMethod(){
        if self.paymentOptionSelected!.getId() == PaymentTypeId.ACCOUNT_MONEY.rawValue {
            self.paymentData.paymentMethod = Utils.findPaymentMethod(self.availablePaymentMethods!, paymentMethodId: paymentOptionSelected!.getId())
            self.next = .REVIEW_AND_CONFIRM
        } else {
            // Se necesita completar información faltante de settings y pm para custom payment options
            let cardInformation = (self.paymentOptionSelected as! CardInformation)
            let paymentMethod = Utils.findPaymentMethod(self.availablePaymentMethods!, paymentMethodId: cardInformation.getPaymentMethodId())
            cardInformation.setupPaymentMethodSettings(paymentMethod.settings)
            cardInformation.setupPaymentMethod(paymentMethod)
            self.paymentData.paymentMethod = cardInformation.getPaymentMethod()
            self.next = .SECURITY_CODE_ONLY
        }
    }
}

