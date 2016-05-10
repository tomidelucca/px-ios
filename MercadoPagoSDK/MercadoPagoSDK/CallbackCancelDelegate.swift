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
    
    func invokeCallbackCancel() {
        self.callbackCancel!()
    }

}
