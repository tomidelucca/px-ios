//
//  CardFormActions.swift
//  MercadoPagoSDKExamples
//
//  Created by Maria cristina rodriguez on 11/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest





class CardFormActions: MPTestActions {

    static internal func testCard( card : TestCard, user : TestUser ){
        
        //Card Form
        let binIndex = card.number.endIndex.advancedBy(6 - card.number.characters.count)
        let binNumber = card.number.substringToIndex(binIndex)
        let additionalNumbers = card.number.substringFromIndex(binIndex)
        let continuarButton = application.navigationBars.buttons["Continuar"]
        let cardNumberField = application.textFields["Número de tarjeta"]
        let cardholderNameField = application.textFields["Nombre y apellido"]
        let expirationDateField = application.textFields["Fecha de expiración"]
        let securityCodeField = application.textFields["Código de seguridad"]
        //Identification Form
        let identificationNumberField = application.textFields["Número"]
        
        cardNumberField.tap()
        cardNumberField.typeText(binNumber)
        continuarButton.tap()
        cardNumberField.typeText(additionalNumbers)
        continuarButton.tap()
        cardholderNameField.typeText(user.name)
        continuarButton.tap()
        expirationDateField.typeText(card.expirationDate)
        continuarButton.tap()
        
        
        if(card.cvv != nil){
            securityCodeField.typeText(card.cvv!)
            continuarButton.tap()
        }
        
        
        
        identificationNumberField.typeText(user.identification.number)
        
        
        
        /*
        continuarButton.pressForDuration(0.2);
        XCUIApplication().tables.staticTexts["3 de $ 397 29 ( $ 1.191 89 ) "].pressForDuration(1.3);
        */
    }
    
 
}






