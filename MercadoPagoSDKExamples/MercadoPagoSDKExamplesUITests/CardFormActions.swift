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
        
        let poCard = POGuessingForm()
        //Card Form
        let binIndex = card.number.endIndex.advancedBy(6 - card.number.characters.count)
        let binNumber = card.number.substringToIndex(binIndex)
        let additionalNumbers = card.number.substringFromIndex(binIndex)
        
        poCard.completeNumeroAndContinue(binNumber)
        poCard.completeNumeroAndContinue(additionalNumbers)
        poCard.completeNombreAndContinue(card.name)
        var poIdentification = poCard.completeFechaAndContinue(card.expirationDate, cvvRequired: card.cvv != nil)
        if (poIdentification == nil){
            poIdentification = poCard.completeCVVAndContinue(card.cvv!)
        }
        poIdentification?.completeNumberAndContinue(user.identification.number)
    }
    
    
   
}






