//
//  PXInstructionsViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 20/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXInstructionsViewModel: NSObject {

    var paymentResult: PaymentResult?
    var instructionsInfo: InstructionsInfo?
    var callback : (PaymentResult.CongratsState) -> Void
    
    init(paymentResult: PaymentResult? = nil, instructionsInfo: InstructionsInfo? = nil,  callback : @escaping ( _ status: PaymentResult.CongratsState) -> Void) {
        self.paymentResult = paymentResult
        self.instructionsInfo = instructionsInfo
        self.callback = callback
    }
    
}
