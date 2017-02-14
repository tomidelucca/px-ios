//
//  CallbackCancelDelegate.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 10/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class CallbackCancelTableViewCell : UITableViewCell {

    var callbackCancel : ((Void) -> Void)?
    var defaultCallback : ((Void) -> Void)?
    var callbackStatus: ((_ paymentResult : PaymentResult, _ status : MPStepBuilder.CongratsState) -> Void)?
    var paymentResult: PaymentResult?
    var status: MPStepBuilder.CongratsState?
    
    func getCallbackStatus() -> ((_ paymentResult : PaymentResult, _ status : MPStepBuilder.CongratsState) -> Void){
        return callbackStatus!
    }
    func setCallbackStatus(callback: @escaping (_ paymentResult : PaymentResult, _ status : MPStepBuilder.CongratsState) -> Void, paymentResult: PaymentResult,status: MPStepBuilder.CongratsState){
        callbackStatus = callback
        self.paymentResult = paymentResult
        self.status = status
    }
    
    func invokeCallbackCancel() {
        self.callbackCancel!()
    }

    func invokeDefaultCallback(){
        if self.defaultCallback != nil {
            self.defaultCallback!()
        }
    }
    func invokeCallback(){
        if let callbackStatus = self.callbackStatus , let paymentResult = paymentResult , let status = status  {
            callbackStatus(paymentResult, status)
        }
    }


    
}
