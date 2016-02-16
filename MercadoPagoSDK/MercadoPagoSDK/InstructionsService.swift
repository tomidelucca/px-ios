//
//  InstructionsService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class InstructionsService: MercadoPagoService {

    public let MP_INSTRUCTIONS_URL = ""
    public let MP_INSTRUCTIONS_URI = ""
    
    public func getInstructionsForPaymentMethodId(paymentMethodId : Int){
    
        self.request(MP_INSTRUCTIONS_URL + MP_INSTRUCTIONS_URI, params: String(paymentMethodId), body: nil, method: "GET", success: { (jsonResult) -> Void in

            }) { (error) -> Void in
                //TODO
        }
    }
}
