//
//  InstructionsService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 16/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class InstructionsService: MercadoPagoService {

<<<<<<< Updated upstream
    public let MP_INSTRUCTIONS_URI = "/beta/checkout/payments/${payment_id}/results"
=======
<<<<<<< Updated upstream
    public let MP_INSTRUCTIONS_URI = "/v1/checkout/payments/${payment_id}/results"
=======
    public let MP_INSTRUCTIONS_URI = ""
>>>>>>> Stashed changes
>>>>>>> Stashed changes
    
    public init(){
        super.init(baseURL: "http://c4560ed8.ngrok.io/")
    }
    
<<<<<<< Updated upstream
    public func getInstructions(paymentId : Int, paymentTypeId: String? = "", success : (instructions : [Instruction]) -> Void, failure: ((error: NSError) -> Void)?){
=======
<<<<<<< Updated upstream
    public func getInstructions(paymentId : Int, paymentMethodId: String, paymentTypeId: String, success : (instruction :Instruction) -> Void, failure: ((error: NSError) -> Void)?){
=======
    public func getInstructions(paymentId : Int, paymentTypeId: String? = "", success : (instructionsInfo : InstructionsInfo) -> Void, failure: ((error: NSError) -> Void)?){
>>>>>>> Stashed changes
>>>>>>> Stashed changes
    
        var params =  "public_key=" + MercadoPagoContext.publicKey()
        if paymentTypeId != nil && paymentTypeId?.characters.count > 0 {
            params = params + "&payment_type=" + paymentTypeId!
        }
        self.request(MP_INSTRUCTIONS_URI.stringByReplacingOccurrencesOfString("${payment_id}", withString: String(paymentId)), params: params, body: nil, method: "GET", cache: false, success: { (jsonResult) -> Void in
<<<<<<< Updated upstream
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
=======
<<<<<<< Updated upstream
            let error = jsonResult?["error"]!
=======
            let error = jsonResult?["error"]
>>>>>>> Stashed changes
            if error != nil {
                let e : NSError = NSError(domain: "com.mercadopago.sdk.getInstructions", code: MercadoPago.ERROR_INSTRUCTIONS, userInfo: [NSLocalizedDescriptionKey : "No se ha podrido obtener las intrucciones correspondientes al pago".localized, NSLocalizedFailureReasonErrorKey : jsonResult!["error"] as! String])
                failure!(error: e)
            } else {
<<<<<<< Updated upstream
                success(instruction : Instruction.fromJSON(jsonResult as! NSDictionary))
=======
                success(instructionsInfo : InstructionsInfo.fromJSON(jsonResult as! NSDictionary))
>>>>>>> Stashed changes
>>>>>>> Stashed changes
            }
        }, failure: failure)
    }
}
