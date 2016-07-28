//
//  InstructionsService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class InstructionsService: MercadoPagoService {

    public let MP_INSTRUCTIONS_URI = "/beta/checkout/payments/${payment_id}/results"
    
    public init(){
        super.init(baseURL: MercadoPagoService.MP_BASE_URL)
    }
    
    public func getInstructions(paymentId : Int, paymentTypeId: String? = "", success : (instructions : [Instruction]) -> Void, failure: ((error: NSError) -> Void)?){
    
        var params =  "public_key=" + MercadoPagoContext.publicKey()
        if paymentTypeId != nil && paymentTypeId?.characters.count > 0 {
            params = params + "&payment_type=" + paymentTypeId!
        }
        self.request(MP_INSTRUCTIONS_URI.stringByReplacingOccurrencesOfString("${payment_id}", withString: String(paymentId)), params: params, body: nil, method: "GET", cache: false, success: { (jsonResult) -> Void in
            let error = jsonResult?["error"]
            let instructionsAvailable = jsonResult as! NSArray
            if error != nil || instructionsAvailable.count != 1 {
                let e : NSError = NSError(domain: "com.mercadopago.sdk.getInstructions", code: MercadoPago.ERROR_INSTRUCTIONS, userInfo: [NSLocalizedDescriptionKey : "No se ha podrido obtener las intrucciones correspondientes al pago".localized, NSLocalizedFailureReasonErrorKey : jsonResult!["error"] as! String])
                failure!(error: e)
            } else {
                var instructions = [Instruction]()
                let jsonResultArr = jsonResult as! NSArray
                for instuctionJson in jsonResultArr {
                    instructions.append(Instruction.fromJSON(instuctionJson as! NSDictionary))
                }
                success(instructions :instructions)
            }
        }, failure: failure)
    }
}
