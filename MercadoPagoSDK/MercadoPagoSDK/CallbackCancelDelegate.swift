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
    var callbackStatusTracking: ((_ paymentResult : PaymentResult, _ status : InstructionsRevampViewController.CongratsState) -> Void)?
    var callbackStatus: ((_ status : InstructionsRevampViewController.CongratsState) -> Void)?
    var paymentResult: PaymentResult?
    var status: InstructionsRevampViewController.CongratsState?
    
    func getCallbackStatus() -> (( _ status : InstructionsRevampViewController.CongratsState) -> Void){
        return callbackStatus!
    }
    func setCallbackStatus(callback: @escaping ( _ status : InstructionsRevampViewController.CongratsState) -> Void, status: InstructionsRevampViewController.CongratsState){
        callbackStatus = callback
        self.status = status
    }
    
    func setCallbackStatusTracking(callback: @escaping (_ paymentResult : PaymentResult, _ status : InstructionsRevampViewController.CongratsState) -> Void, paymentResult: PaymentResult,status: InstructionsRevampViewController.CongratsState){
        callbackStatusTracking = callback
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
        if let paymentResult = paymentResult, let callbackStatusTracking = self.callbackStatusTracking , let status = status{
            callbackStatusTracking(paymentResult, status)
        } else if let callbackStatus = self.callbackStatus , let status = status  {
            callbackStatus(status)
        }
    }
    
}
