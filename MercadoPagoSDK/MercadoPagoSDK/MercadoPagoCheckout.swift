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
    
    
    init(/* parameters */navigationController : UINavigationController) {
        viewModel = MercadoPagoCheckoutViewModel()
        self.navigationController = navigationController
    }
    
    func start(){
        
       
        executeNextStep()
    }
    
    
    func executeNextStep(optionSelected: String? = nil){
        switch self.viewModel.nextStep() {
        case CheckoutStep.SEARCH_PAYMENT_METHODS:
            self.collectCreditCard()
        default:
             self.collectCreditCard()
        }
       
        
    }
    
    func collectCreditCard(){
        let cardForm = CardFormViewController(cardFormManager: self.viewModel.cardFormManager(), callback: { (paymentMethods, cardToken) in
            self.viewModel.updateCheckoutModel(paymentMethods: paymentMethods, cardToken:cardToken)
            self.executeNextStep()
        })
        self.navigationController.pushViewController(cardForm, animated: true)
    }
    
}
