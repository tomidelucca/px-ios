//
//  MockCheckoutViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

class MockCheckoutViewController: CheckoutViewController {
    
    var paymentVaultLoaded = false
    
    override init(preference : CheckoutPreference, callback : (Payment -> Void)){
        super.init(preference: preference, callback: callback)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override internal func startPaymentVault(){
        paymentVaultLoaded = true
    }
}
