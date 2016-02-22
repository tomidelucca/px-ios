//
//  InstructionsService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class InstructionsService: MercadoPagoService {

    public let MP_INSTRUCTIONS_URL = "http://private-69c94c-instructionsapi.apiary-mock.com"
    public let MP_INSTRUCTIONS_URI = "/instructions/v1"
    
    public init(){
        super.init(baseURL: MP_INSTRUCTIONS_URL)
    }
    
    public func getInstructionsForPaymentId(paymentId : String, success : (instruction :Instruction) -> Void, failure: ((error: NSError) -> Void)?){
    
        self.request(MP_INSTRUCTIONS_URI + "/" + paymentId, params: nil, body: nil, method: "GET", success: { (jsonResult) -> Void in
            success(instruction : Instruction.fromJSON(jsonResult as! NSDictionary))
        }, failure: failure)
    }
}
