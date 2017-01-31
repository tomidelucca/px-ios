//
//  MercadoPagoCheckout.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/23/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

open class MercadoPagoCheckout: NSObject {

    var viewModel : MercadoPagoCheckoutViewModel
    var navigationController : UINavigationController!
    var viewControllerBase : UIViewController?
    
   public init(/* parameters & preferences */navigationController : UINavigationController) {
        viewModel = MercadoPagoCheckoutViewModel()
        self.navigationController = navigationController
    
        if self.navigationController.viewControllers.count > 0 {
            viewControllerBase = self.navigationController.viewControllers[0]
        }
    }
    
    public func start(){
        executeNextStep()
    }


    
    func executeNextStep(optionSelected: String? = nil){
        switch self.viewModel.nextStep() {
        case .SEARCH_PAYMENT_METHODS :
            self.collectPaymentMethodSearch()
        case .PAYMENT_METHOD :
            self.collectPaymentMethods()
        case CheckoutStep.CARD_FORM:
            self.collectCard()
        case CheckoutStep.CREDIT_DEBIT:
            self.collectCreditDebit()
        case CheckoutStep.ISSUER:
            self.collectIssuer()
        case CheckoutStep.PAYER_COST:
            self.collectPayerCost()
        case .REVIEW_AND_CONFIRM :
            self.collectPaymentData()
        case CheckoutStep.FINISH:
            self.finish()
        default:
             self.error()
        }
    }
    
    func collectPaymentMethodSearch(){
        //TODO :  EXCLUSIONES
        MPServicesBuilder.searchPaymentMethods(self.viewModel.amount, defaultPaymenMethodId: nil, excludedPaymentTypeIds: nil, excludedPaymentMethodIds: nil,
                success: { (paymentMethodSearchResponse: PaymentMethodSearch) -> Void in
                    self.viewModel.updateCheckoutModel(paymentMethodOptions: paymentMethodSearchResponse.groups, availablePaymentMethods : paymentMethodSearchResponse.paymentMethods)
                    self.executeNextStep()
                    
        }, failure: { (error) -> Void in
            self.viewModel.next = .ERROR
            self.executeNextStep()
        })

    }
    
    func collectPaymentMethods(){
        let paymentMethodSelectionStep = PaymentVaultViewController(viewModel: self.viewModel.paymentVaultViewModel(), callback : { (paymentMethodSelected : PaymentMethodOption) -> Void  in
            self.viewModel.updateCheckoutModel(paymentMethodSelected : paymentMethodSelected)
            self.executeNextStep()
        })
        self.navigationController.pushViewController(paymentMethodSelectionStep, animated: true)
    }
    
    func collectCard(){
        
        let cardFormStep = CardFormViewController(cardFormManager: self.viewModel.cardFormManager(), callback: { (paymentMethods, cardToken) in
            self.viewModel.updateCheckoutModel(paymentMethods: paymentMethods, cardToken:cardToken)
            self.executeNextStep()
        })
        self.navigationController.pushViewController(cardFormStep, animated: true)
    }
    
    func collectCreditDebit(){
        let crediDebitStep = CardAdditionalViewController(viewModel: self.viewModel.debitCreditViewModel(), collectPaymentMethodCallback: { (paymentMethod) in
            self.viewModel.updateCheckoutModel(paymentMethod: paymentMethod)
            self.executeNextStep()
        })
        self.navigationController.pushViewController(crediDebitStep, animated: true)
    }
    
    func collectIssuer(){
        let issuerStep = CardAdditionalViewController(viewModel: self.viewModel.issuerViewModel(), collectIssuerCallback: { (issuer) in
            self.viewModel.updateCheckoutModel(issuer: issuer)
            self.executeNextStep()
        })
        self.navigationController.pushViewController(issuerStep, animated: true)
    }
    
    func collectPayerCost(){
        let payerCostStep = CardAdditionalViewController(viewModel: self.viewModel.payerCostViewModel(), collectPayerCostCallback: { (payerCost) in
            self.viewModel.updateCheckoutModel(payerCost: payerCost)
            self.executeNextStep()
        })
        self.navigationController.pushViewController(payerCostStep, animated: true)
    }
    
    func collectPaymentData() {
        // RyC step
        print("RyC!")
    }
    
    func error() {
        // Display error
    }
    
    func finish(){
        
        if let rootViewController = viewControllerBase{
            self.navigationController.popToViewController(rootViewController, animated: false)
        }else{
            self.navigationController.dismiss(animated: true, completion: { 
                // --- Nothing
            })
        }
        
        
        
    }
}
