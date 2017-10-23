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

    
    init(paymentResult: PaymentResult? = nil, instructionsInfo: InstructionsInfo? = nil)  {
        self.paymentResult = paymentResult
        self.instructionsInfo = instructionsInfo
    }
    
}
