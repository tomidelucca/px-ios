//
//  CardInformation.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/8/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

@objc
public protocol CardInformation : NSObjectProtocol {

    func getPaymentMethodId() -> String
    
    func getCardDescription() -> String
    
    func getPaymentMethod() -> PaymentMethod
    
}
