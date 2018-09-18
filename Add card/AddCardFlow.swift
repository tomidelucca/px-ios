//
//  AddCardFlow.swift
//  MercadoPagoSDK
//
//  Created by Diego Flores Domenech on 6/9/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

@objcMembers
public class AddCardFlow: NSObject, PXFlow {
    
    private let accessToken: String
    private let model = AddCardFlowModel()
    private let navigationHandler: PXNavigationHandler
    
    public init(accessToken: String, navigationController: UINavigationController) {
        self.accessToken = accessToken
        self.navigationHandler = PXNavigationHandler(navigationController: navigationController)
        super.init()
    }
    
    public func start() {
        self.executeNextStep()
    }
    
    func executeNextStep(){
        switch self.model.nextStep() {
        case .getPaymentMethods:
            self.getPaymentMethods()
        case .openCardForm:
            self.openCardForm()
        case .createToken:
            self.createCardToken()
        case .associateTokenWithUser:
            self.associateTokenWithUser()
        case .finish:
            self.finish()
        default:
            break
        }
    }
    
    func cancelFlow(){
        
    }
    
    func finishFlow(){
        
    }
    
    func exitCheckout(){
        
    }
    
    //MARK: steps
    
    private func getPaymentMethods() {
        self.navigationHandler.presentLoading()
        let service = PaymentMethodsUserService(accessToken: self.accessToken)
        service.getPaymentMethods(success: { [weak self] (paymentMethods) in
            self?.model.paymentMethods = paymentMethods
            self?.navigationHandler.dismissLoading()
            self?.executeNextStep()
        }) { [weak self] (error) in
            self?.navigationHandler.dismissLoading()
        }
    }
    
    private func openCardForm() {
        guard let paymentMethods = self.model.paymentMethods else {
            return
        }
        let cardFormViewModel = CardFormViewModel(paymentMethods: paymentMethods, guessedPaymentMethods: nil, customerCard: nil, token: nil, mercadoPagoServicesAdapter: nil, bankDealsEnabled: false)
        let cardFormViewController = CardFormViewController(cardFormManager: cardFormViewModel, callback: { [weak self](paymentMethods, cardToken) in
            self?.model.cardToken = cardToken
            self?.model.selectedPaymentMethod = paymentMethods.first
            self?.executeNextStep()
        })
        self.navigationHandler.pushViewController(targetVC: cardFormViewController, animated: true)
    }
    
    private func createCardToken() {
        guard let cardToken = self.model.cardToken else {
            return
        }
        self.navigationHandler.presentLoading()
        let mercadoPagoServicesAdapter = MercadoPagoServicesAdapter(publicKey: "APP_USR-5bd14fdd-3807-446f-babd-095788d5ed4d", privateKey: self.accessToken)
        mercadoPagoServicesAdapter.createToken(cardToken: cardToken, callback: { [weak self] (token) in
            self?.navigationHandler.dismissLoading()
            self?.model.tokenizedCard = token
            self?.executeNextStep()
            }, failure: {[weak self] (error) in
            self?.navigationHandler.dismissLoading()
        })
    }
    
    private func associateTokenWithUser() {
        guard let selectedPaymentMethod = self.model.selectedPaymentMethod, let token = self.model.tokenizedCard else {
            return
        }
        self.navigationHandler.presentLoading()
        let associateCardService = AssociateCardService(accessToken: self.accessToken)
        associateCardService.associateCardToUser(paymentMethod: selectedPaymentMethod, cardToken: token, success: { [weak self] (json) in
            self?.navigationHandler.dismissLoading()
            print(json)
            self?.executeNextStep()
        }) { [weak self] (error) in
            self?.navigationHandler.dismissLoading()
        }
    }
    
    private func finish() {
        self.navigationHandler.goToRootViewController()
    }

}
