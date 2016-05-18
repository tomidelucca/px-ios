//
//  MPStepBuilder.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

public class MPStepBuilder : NSObject {
    
    
    
    public class func startCustomerCardsStep(cards: [Card], callback: (selectedCard: Card?) -> Void) -> CustomerCardsViewController {
        return CustomerCardsViewController(cards: cards, callback: callback)
    }
    
    public class func startNewCardStep(paymentMethod: PaymentMethod, requireSecurityCode: Bool = true, callback: (cardToken: CardToken) -> Void) -> NewCardViewController {
        
        return NewCardViewController(paymentMethod: paymentMethod, requireSecurityCode: requireSecurityCode, callback: callback)
        
    }
    
    public class func startPaymentMethodsStep(supportedPaymentTypes: Set<PaymentTypeId>, callback:(paymentMethod: PaymentMethod) -> Void) -> PaymentMethodsViewController {
        
        return PaymentMethodsViewController(supportedPaymentTypes: supportedPaymentTypes, callback: callback)
    }
    
    public class func startIssuersStep(paymentMethod: PaymentMethod, callback: (issuer: Issuer) -> Void) -> IssuersViewController {
        return IssuersViewController(paymentMethod: paymentMethod, callback: callback)
    }
    
    public class func startInstallmentsStep(payerCosts: [PayerCost], amount: Double, callback: (payerCost: PayerCost?) -> Void) -> InstallmentsViewController {
        return InstallmentsViewController(payerCosts: payerCosts, amount: amount, callback: callback)
    }
    
    @available(*, deprecated=2.0, message="Use startPaymentCongratsStep instead")
    public class func startCongratsStep(payment: Payment, paymentMethod: PaymentMethod) -> CongratsViewController {
        return CongratsViewController(payment: payment, paymentMethod: paymentMethod)
    }

    public class func startPaymentCongratsStep(payment: Payment, callbackCancel : (Void -> Void)? = nil) -> PaymentCongratsViewController {
        return PaymentCongratsViewController(payment: payment, callbackCancel : callbackCancel)
    }
    
    public class func startInstructionsStep(payment: Payment, callback : (payment : Payment) -> Void) -> InstructionsViewController {
        return InstructionsViewController(payment: payment, callback : callback)
    }
    
    public class func startPromosStep() -> PromoViewController {
        return PromoViewController()
    }
    

    public class func startCreditCardForm(paymentSettings : PaymentPreference? , amount: Double, token: Token? = nil ,callback : ((paymentMethod: PaymentMethod, token: Token? ,  issuer: Issuer?) -> Void), callbackCancel : (Void -> Void)?) -> UINavigationController {

        var navigation : UINavigationController?
        var ccf : CardFormViewController = CardFormViewController()

        ccf = CardFormViewController(paymentSettings : paymentSettings , amount: amount, token: token, callback : { (paymentMethod, cardToken,  issuer) -> Void in
            
            if(paymentMethod.isIdentificationRequired()){
                let identificationForm = MPStepBuilder.startIdentificationForm({ (identification) -> Void in
                    cardToken?.cardholder?.identification = identification
                    MPServicesBuilder.getIssuers(paymentMethod,bin: cardToken!.getBin(), success: { (issuers) -> Void in
                            if(issuers!.count > 1){
                                let issuerForm = MPStepBuilder.startIssuerForm(paymentMethod, cardToken: cardToken!, issuerList: issuers, callback: { (issuer) -> Void in
                                    MPServicesBuilder.createNewCardToken(cardToken!, success: { (token) -> Void in
                                        callback(paymentMethod: paymentMethod, token: token, issuer:issuer)
                                        }) { (error) -> Void in
                                            print(error)
                                    }
                                })
                                issuerForm.callbackCancel = { Void -> Void in
                                    ccf.navigationController!.dismissViewControllerAnimated(true, completion: {
                                        print("LLEGUE!")
                                    })
                                }
                                
                                ccf.navigationController!.pushViewController(issuerForm, animated: false)
                            }else{
                                MPServicesBuilder.createNewCardToken(cardToken!, success: { (token) -> Void in
                                    callback(paymentMethod: paymentMethod, token: token, issuer:issuers![0])
                                    }) { (error) -> Void in
                                        print(error)
                                }
                            }
                        
                        }) { (error) -> Void in
                            print("error")
                    }
                   
                })

                identificationForm.callbackCancel = callbackCancel                
                
                ccf.navigationController!.pushViewController(identificationForm, animated: false)
                
                
            }else{
                
            }
            
            
            },callbackCancel: callbackCancel)
        navigation = MPFlowController.createNavigationControllerWith(ccf)
        
        return navigation!

    }
    
    
    public class func startPayerCostForm(paymentMethod : PaymentMethod? , issuer:Issuer?, token : Token , amount: Double, minInstallments : Int?,installment : Installment? = nil,  callback : ((payerCost: PayerCost?) -> Void)) -> PayerCostViewController {
        
        
        return PayerCostViewController(paymentMethod: paymentMethod, issuer: issuer, token: token, amount: amount, maxInstallments: minInstallments, installment : installment, callback: callback)
       // return PaymentInstallmentsViewController(paymentType : paymentType , callback : callback)
    }
    
    public class func startIdentificationForm( callback : ((identification: Identification?) -> Void)) -> IdentificationViewController {
        
        
        return IdentificationViewController(callback: callback)
    }
    
    
    public class func startIssuerForm(paymentMethod: PaymentMethod, cardToken: CardToken, issuerList: [Issuer]? = nil, callback : ((issuer: Issuer?) -> Void)) -> IssuerCardViewController {
        
        
        return IssuerCardViewController(paymentMethod: paymentMethod, cardToken: cardToken, callback: callback)
    }
    
    public class func startErrorViewController(error : MPError, callback : (Void -> Void)? = nil) -> UIViewController {
        return ErrorViewController(error: error, callback: callback)
    }
}

