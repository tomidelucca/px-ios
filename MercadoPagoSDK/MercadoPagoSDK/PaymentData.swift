//
//  PaymentData.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 2/1/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentData: NSObject {

    var paymentMethod : PaymentMethod?
    var issuer : Issuer?
    var payerCost : PayerCost?
    var token : Token?
    
    
    
    
    func complete() -> Bool {
        
        /*
        if paymentMethod == nil {
            return false
        }
        if issuer == nil {
            return false
        }
        if payerCost == nil {
            return false
        }
        if token == nil {
            return false
        }
         */
        return true // Deberia devolver true en caso de tener todo lo necesario para hacer el pago
        
    }
}
