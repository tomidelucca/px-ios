//
//  GuessingFormTest.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 4/14/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class GuessingFormTest: BaseTest {

    
     var cardFormViewController : CardFormViewController?
    
    
    override func setUp() {
        super.setUp()
        MercadoPagoContext.setPublicKey(MockBuilder.MLA_PK)
    }

    
    /*Test guessing con Amex , Visa y Mastercard*/
    func testCreditCardFormWithoutSettings(){
        
        self.cardFormViewController = CardFormViewController(paymentSettings: nil, amount: 1000, token: nil, paymentMethods: nil, callback: { (paymentMethod, cardToken) in
            
            }, callbackCancel: {
                
        })
        MercadoPagoTestContext.sharedInstance.expectation = expectationWithDescription("waitForPaymentMethods")
        self.simulateViewDidLoadFor(self.cardFormViewController!)

        waitForExpectationsWithTimeout(60, handler: nil)
        self.cardFormViewController?.textBox?.delegate = self.cardFormViewController
       
       self.checkCards()
    }
    
    /*Test con lista de metodos de pago de parametros de entrada*/
    func testCreditCardFormWithPaymentMethodList(){

        var pms : [PaymentMethod] = []
        MercadoPagoTestContext.sharedInstance.expectation = expectationWithDescription("waitPMs")
        
        MPServicesBuilder.getPaymentMethods({ (paymentMethods) -> Void in
            pms = paymentMethods!
        }) { (error) -> Void in
        }
        waitForExpectationsWithTimeout(60, handler: nil)
        
        self.cardFormViewController = CardFormViewController(paymentSettings: nil, amount: 1000, token: nil, paymentMethods: pms, callback: { (paymentMethod, cardToken) in
            
            }, callbackCancel: {
                
        })
        self.simulateViewDidLoadFor(self.cardFormViewController!)
      
        self.cardFormViewController?.textBox?.delegate = self.cardFormViewController
        
       self.checkCards()
    }
    
    /* Test excluyendo Visa (Testea que anden el resto de las tarjeas y que rechace Visa)*/
    func testPreferencePM(){
        let pp :PaymentPreference? = PaymentPreference(defaultPaymentTypeId: nil, excludedPaymentMethodsIds: ["visa"], excludedPaymentTypesIds: nil, defaultPaymentMethodId: nil, maxAcceptedInstallment: nil, defaultInstallments: nil)
        var pms : [PaymentMethod] = []
        MercadoPagoTestContext.sharedInstance.expectation = expectationWithDescription("waitPMs")
        
        MPServicesBuilder.getPaymentMethods({ (paymentMethods) -> Void in
            pms = paymentMethods!
        }) { (error) -> Void in
        }
        waitForExpectationsWithTimeout(60, handler: nil)
        
        self.cardFormViewController = CardFormViewController(paymentSettings: pp, amount: 1000, token: nil, paymentMethods: pms, callback: { (paymentMethod, cardToken) in
            
            }, callbackCancel: {
                
        })
        self.simulateViewDidLoadFor(self.cardFormViewController!)
        
        self.cardFormViewController?.textBox?.delegate = self.cardFormViewController
        
        //MASTER
        checkPaymentMethodGuessing("5031755734530604", pmId: "master")
        //AMEX
        checkPaymentMethodGuessing("371180303257522", pmId: "amex")
        //VISA
        checkPaymentNotMachingMethodGuessing("4170068810108020", pmId: "visa")
        
    }
    
    
    /* Test excluyendo Tarjeta de Credito (Testea que rechace Visa, Amex y Mastercard)*/
    func testPreferencePT(){
        let pp :PaymentPreference? = PaymentPreference(defaultPaymentTypeId: nil, excludedPaymentMethodsIds: nil, excludedPaymentTypesIds: ["credit_card"], defaultPaymentMethodId: nil, maxAcceptedInstallment: nil, defaultInstallments: nil)
        var pms : [PaymentMethod] = []
        MercadoPagoTestContext.sharedInstance.expectation = expectationWithDescription("waitPMs")
        
        MPServicesBuilder.getPaymentMethods({ (paymentMethods) -> Void in
            pms = paymentMethods!
            //     MercadoPagoTestContext.fulfillExpectation()
        }) { (error) -> Void in
            // Mensaje de error correspondiente, ver que hacemos con el flujo
        }
        waitForExpectationsWithTimeout(60, handler: nil)
        
        self.cardFormViewController = CardFormViewController(paymentSettings: pp, amount: 1000, token: nil, paymentMethods: pms, callback: { (paymentMethod, cardToken) in
            
            }, callbackCancel: {
                
        })
        self.simulateViewDidLoadFor(self.cardFormViewController!)
        
        self.cardFormViewController?.textBox?.delegate = self.cardFormViewController
        
        //MASTER
        checkPaymentNotMachingMethodGuessing("5031755734530604", pmId: "master")
        //AMEX
        checkPaymentNotMachingMethodGuessing("371180303257522", pmId: "amex")
        //VISA
        checkPaymentNotMachingMethodGuessing("4170068810108020", pmId: "visa")
        
    }
    
    
    func checkCards (){
        //VISA
        checkPaymentMethodGuessing("4170068810108020", pmId: "visa")
        //MASTER
        checkPaymentMethodGuessing("5031755734530604", pmId: "master")
        //AMEX
        checkPaymentMethodGuessing("371180303257522", pmId: "amex")
    }
    
    func checkPaymentMethodGuessing(number: String, pmId: String){
        let binIndex = number.endIndex.advancedBy(7 - number.characters.count)
        let binNumber = number.substringToIndex(binIndex)
        self.cardFormViewController?.textBox?.text = binNumber
        self.cardFormViewController?.cardNumberLabel?.text = binNumber
        self.cardFormViewController?.numberLabelEmpty = false
        self.cardFormViewController?.updateCardSkin()
        XCTAssertNotNil(self.cardFormViewController?.paymentMethod)
        XCTAssert(self.cardFormViewController?.paymentMethod?._id == pmId)
    }

    func checkPaymentNotMachingMethodGuessing(number: String, pmId: String){
        let binIndex = number.endIndex.advancedBy(7 - number.characters.count)
        let binNumber = number.substringToIndex(binIndex)
        self.cardFormViewController?.textBox?.text = binNumber
        self.cardFormViewController?.cardNumberLabel?.text = binNumber
        self.cardFormViewController?.numberLabelEmpty = false
        self.cardFormViewController?.updateCardSkin()
        XCTAssertNil(self.cardFormViewController?.paymentMethod)
        XCTAssertNotEqual(self.cardFormViewController?.paymentMethod?._id , pmId)
    }
    
}
