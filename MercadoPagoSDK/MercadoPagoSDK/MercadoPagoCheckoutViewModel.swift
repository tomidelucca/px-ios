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
    case CREDIT_DEBIT
    case ISSUER
    case IDENTIFICATION
    case PAYER_COST
    case REVIEW_AND_CONFIRM
    case CONGRATS
    case FINISH
    case ERROR
}



open class MercadoPagoCheckoutViewModel: NSObject {

    let amount : Double = 1000
    var paymentMethods : [PaymentMethod]?
    var cardToken: CardToken?
    var payerCost: PayerCost?
    var paymentMethodSelected : PaymentOptionDrawable?
    
    /// VER QUIZAS NO IRIA ACA
    var paymentMethodSearch : PaymentMethodSearch?
    
    // flowpreference
    //
    //
    //
    //
    //
    
    
    //--- PAYMENT DATA
    
    var selectedPaymentMethod : PaymentMethod?
    var selectedIssuer : Issuer?
    var selectedPayerCost : PayerCost?
    
    //----------------
    
    
    var next : CheckoutStep = .SEARCH_PAYMENT_METHODS
    
    
    
    
    public func getPaymentPreferences() -> PaymentPreference? {
        return nil
    }
    
    public func updateCheckoutModel(paymentMethodSearch : PaymentMethodSearch) {
        self.paymentMethodSearch = paymentMethodSearch
        self.next = CheckoutStep.PAYMENT_METHOD
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
        // TODO : Customer payment methods!
        let paymentMethodOptions : [PaymentOptionDrawable] = self.paymentMethodSearch!.groups //as! [PaymentOptionDrawable])
        return PaymentVaultViewModel(amount: self.amount, paymentPrefence: getPaymentPreferences(), paymentMethodOptions: paymentMethodOptions)
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
    
    public func updateCheckoutModel(paymentMethodSelected : PaymentOptionDrawable){
        self.paymentMethodSelected = paymentMethodSelected
        // Tener en cuenta si es customer card, ti tiene children y toda la pelota
//        if (paymentSearchItemSelected.children.count > 0) {
//            self.callback(paymentSearchItemSelected)
//        } else {
//            self.showLoading()
//            self.viewModel.optionSelected(paymentSearchItemSelected, navigationController: self.navigationController!, cancelPaymentCallback: cardFormCallbackCancel())
//        }
        
        
    }
    
    public func nextStep() -> CheckoutStep {
        // --  --
        return next
    }
    
   
    
}

