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
        MercadoPagoContext.setPublicKey(MockBuilder.MOCK_PUBLIC_KEY)

        self.cardFormViewController = MPStepBuilder.startCreditCardForm(nil, amount: 10000, callback: { (paymentMethod, cardToken, issuer, installment) -> Void in
            
        })
        self.simulateViewDidLoadFor(self.cardFormViewController!)
    }

    func testCreditCardScreen(){
        MercadoPagoUIViewController.loadFont(MercadoPago.DEFAULT_FONT_NAME)
        
    }

    /**
      Si se pasa este test, 
      la pantalla se levanta correctamente y
      cada elemento necesiario para la interfaz grafica es correctamente inicializado.
    */
    func testViewDidLoad() {
        
        XCTAssertNotNil(self.cardFormViewController?.textBox)
        XCTAssertNotNil(self.cardFormViewController?.promoButton)
        XCTAssertNotNil(self.cardFormViewController?.cardView)
    } 
    
    /**
     Si se pasa este test,
     El guessing detecta correctamente tarjetas VISA
     */
    func testGuessingVISA(){
        cardFormViewController?.textBox?.text = "4544 4466"
        cardFormViewController?.editingChanged(cardFormViewController!.textBox!)
        XCTAssertTrue(cardFormViewController!.paymentMethod!.isVISA())
    }
    /**
     Si se pasa este test,
     El guessing detecta correctamente tarjetas MASTERCARD
     */
    func testGuessingMASTER(){
        cardFormViewController?.textBox?.text = "5355 5558"
        cardFormViewController?.editingChanged(cardFormViewController!.textBox!)
        XCTAssertTrue(cardFormViewController!.paymentMethod!.isMASTERCARD())
    }
    
    
    /**
     Si se pasa este test,
     Cuando el guessing falla limpia el paymentMethod seleccionado.
     */
    func testGuessingNoResult(){
        cardFormViewController?.textBox?.text = "5355 5558"
        cardFormViewController?.editingChanged(cardFormViewController!.textBox!)
        XCTAssertTrue(cardFormViewController!.paymentMethod!.isMASTERCARD())
        cardFormViewController?.textBox?.text = "0101 0909"
        cardFormViewController?.editingChanged(cardFormViewController!.textBox!)
        XCTAssertNil(cardFormViewController!.paymentMethod)
    }
    
    
    
    /**
     Si se pasa este test,
     La navegacion automatica entre los campos a completar es correcta.
     */
    func testTextFieldSelection(){
        
        cardFormViewController?.editingLabel = cardFormViewController?.cardNumberLabel
        cardFormViewController?.textBox?.text = "4544 4466 5555 6099 "
        cardFormViewController?.editingChanged(cardFormViewController!.textBox!)
        XCTAssertEqual(cardFormViewController?.editingLabel, cardFormViewController?.nameLabel)
        cardFormViewController?.textBox?.text = "Jose de San Martin  "
         cardFormViewController?.editingChanged(cardFormViewController!.textBox!)
        XCTAssertEqual(cardFormViewController?.editingLabel, cardFormViewController?.expirationDateLabel)
        cardFormViewController?.textBox?.text = "11/40"
        cardFormViewController?.editingChanged(cardFormViewController!.textBox!)
        XCTAssertEqual(cardFormViewController?.editingLabel, cardFormViewController?.cvvLabel)
        cardFormViewController?.textBox?.text = "101"
        cardFormViewController?.confirmPaymentMethod()
        XCTAssertEqual(cardFormViewController?.cardNumberLabel?.textColor, MPLabel.errorColorText)

    }
    
 
    
    /*
    Dado valores validos para la creacion de la tarjeta
    se crea el cardtoken correspondiente de forma correcta
    **/
    
    
    /*
    El field del numero de la tarjeta se marque como erroneo
    en caso de que no se ingrese el numero de tarjeta
    y se intente crear el cardtoken
    **/
    
    /*
    el campo de date se marca como erroneo en caso de ingresar una fecha no valida
    */
    
    /*
    el campo de nombre se marca como erroneo en caso de no ingresar nombre
    */
    
    /*
    el campo de cvv se marca como erroneo en caso de no ingresar cvv
    */
    
}
