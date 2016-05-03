//
//  InstructionsService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class InstructionsService: MercadoPagoService {

    public let MP_INSTRUCTIONS_URL = "https://api.mercadopago.com"
    //public let MP_INSTRUCTIONS_URL = "http://private-9376e-paymentmethodsmla.apiary-mock.com"
    public let MP_INSTRUCTIONS_URI = "/beta/checkout/instructions"
    
    public init(){
        super.init(baseURL: MP_INSTRUCTIONS_URL)
    }
    
    public func getInstructions(paymentId : Int, paymentMethodId: String, paymentTypeId: String, success : (instruction :Instruction) -> Void, failure: ((error: NSError) -> Void)?){
    
        let params =  "public_key=" + MercadoPagoContext.publicKey() + "&payment_method_id=" + paymentMethodId + "&payment_type_id=" + paymentTypeId
        self.request(MP_INSTRUCTIONS_URI + "/" + String(paymentId), params: params, body: nil, method: "GET", success: { (jsonResult) -> Void in
            success(instruction : Instruction.fromJSON(jsonResult as! NSDictionary))
        }, failure: failure)
    }
}
