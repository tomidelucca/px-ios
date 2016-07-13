//
//  CardFormActions.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 11/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class CardFormActions: NSObject {

    static func fillCreditCardForm(app : XCUIApplication){
        
        app.textFields["Número de tarjeta"].tap()
        let cardNumberField = app.textFields["Número de tarjeta"]
        cardNumberField.typeText("450995")
        
        let continuarButton = app.navigationBars.buttons["Continuar"]
        continuarButton.tap()
        cardNumberField.typeText("3566233704")
        continuarButton.tap()
        let cardholderNameField = app.textFields["Nombre y apellido"]
        cardholderNameField.typeText("APRO")
        continuarButton.tap()
        
        let expirationDateField = app.textFields["Fecha de expiración"]
        expirationDateField.typeText("1122")
        continuarButton.tap()
        
        let securityCodeField = app.textFields["Código de seguridad"]
        securityCodeField.typeText("123")
        continuarButton.tap()
        
        let identificationNumberField = app.textFields["Número"]
        identificationNumberField.typeText("12123123")
        
        continuarButton.pressForDuration(0.2);
        
        XCUIApplication().tables.staticTexts["3 de $ 397 29 ( $ 1.191 89 ) "].pressForDuration(1.3);

    }
}
