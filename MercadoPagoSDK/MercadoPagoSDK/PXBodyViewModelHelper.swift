//
//  PXBodyViewModelHelper.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/27/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

extension PXResultViewModel {

    open func bodyComponentProps() -> PXBodyProps {
        let props = PXBodyProps(paymentResult: self.paymentResult, amount: self.amount, instruction: getInstrucion())
        return props
    }

    open func getInstrucion() -> Instruction? {
        guard let instructionsInfo = self.instructionsInfo else {
            return nil
        }
        return instructionsInfo.getInstruction()
    }
}
