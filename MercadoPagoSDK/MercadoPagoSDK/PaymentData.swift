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
    
    func clear() {
        self.paymentMethod = nil
        self.issuer = nil
        self.payerCost = nil
        self.token = nil
    }
    
    
    func complete() -> Bool {
        
        
        if paymentMethod == nil {
            return false
        }
        
        if paymentMethod!.isCard() && (token == nil || payerCost == nil) {
            return false
        }
        
//        if paymentMethod.isissuer == nil {
//            return false
//        }

        return true
        
    }
}
