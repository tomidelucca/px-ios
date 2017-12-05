//
//  PXBodyViewModelHelper.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/27/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

extension PXResultViewModel {

    open func getBodyComponentProps() -> PXBodyProps {
        let props = PXBodyProps(paymentResult: self.paymentResult, amount: self.amount, instruction: getInstrucion(), callback: getAction())
        return props
    }

    open func getInstrucion() -> Instruction? {
        guard let instructionsInfo = self.instructionsInfo else {
            return nil
        }
        return instructionsInfo.getInstruction()
    }
    
    func getAction() -> (() -> Void) {
        return { self.pressButtonBody() }
    }
    
    func pressButtonBody() {
        self.callback(PaymentResult.CongratsState.call_FOR_AUTH)
        
//        if self.isAccepted() {
//            self.callback(PaymentResult.CongratsState.ok)
//        } else if self.isError() {
//            self.callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
//        } else if self.isWarning() {
//            if self.paymentResult.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || self.paymentResult.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT {
//                self.callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
//            }else {
//                self.callback(PaymentResult.CongratsState.cancel_RETRY)
//            }
//        }
    }
}
