//
//  MockPaymentVaultViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation

class MockPaymentVaultViewController: PaymentVaultViewController {
    
    var mpStylesLoaded = false
    var mpStylesCleared = false
    var cardFlowStarted = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.mpStylesLoaded = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.mpStylesCleared = true
    }
    
    override internal func executeBack(){
        super.executeBack()
        
    }
    
  /*  override internal func loadMPStyles(){
        self.mpStylesLoaded = true
    }*/

    
    override internal func clearMercadoPagoStyle(){
        self.mpStylesCleared = true
    }
    
    override internal func togglePreferenceDescription(){
        self.togglePreferenceDescription(self.paymentsTable)
    }
    
    internal override func cardFlow(paymentType: PaymentType, animated : Bool){
        super.cardFlow(paymentType, animated: true)
        self.cardFlowStarted = true
    }

}
