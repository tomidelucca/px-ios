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
        case .associateTokenWithUser:
            self.associateTokenWithUser()
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
        service.getPaymentMethods(success: { (paymentMethods) in
            self.navigationHandler.dismissLoading()
            self.executeNextStep()
        }) { (error) in
            self.navigationHandler.dismissLoading()
        }
    }
    
    private func openCardForm() {
        
    }
    
    private func associateTokenWithUser() {
        
    }

}
