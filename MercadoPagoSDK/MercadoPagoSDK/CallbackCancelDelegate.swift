//
//  CallbackCancelDelegate.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 10/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CallbackCancelTableViewCell : UITableViewCell {

    var callbackCancel : (Void -> Void)?
    var startPaymentVault : (Void -> Void)?
    var calledForAuthorize : (Void -> Void)?
    
    func invokeCallbackCancel() {
        self.callbackCancel!()
    }

    func invokeStartPaymentVault(){
        if self.startPaymentVault != nil {
            self.startPaymentVault!()
        }
    }
    
    func invokeCalledForAuthorize(){
        if self.calledForAuthorize != nil {
            self.calledForAuthorize!()
        }
    }
    
}
