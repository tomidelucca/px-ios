//
//  MPFlowBuilder.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation

public class MPFlowBuilder : NSObject {
    
    
    @available(*, deprecated=2.0, message="Use startCheckoutViewController instead")
    public class func startVaultViewController(amount: Double, supportedPaymentTypes: Set<PaymentTypeId>?, callback: (paymentMethod: PaymentMethod, tokenId: String?, issuer: Issuer?, installments: Int) -> Void) -> VaultViewController {
        
        return VaultViewController(amount: amount, supportedPaymentTypes: supportedPaymentTypes, callback: callback)
        
    }
    
    public class func starCheckoutViewController(preference: CheckoutPreference, callback: (MerchantPayment) -> Void) -> CheckoutViewController {
        return CheckoutViewController(preference: preference, callback: callback)
        
    }
    
    public class func startPaymentVaultViewController(amount: Double, excludedPaymentTypes: Set<PaymentTypeId>?, excludedPaymentMethods : [String]?, callback: (paymentMethod: PaymentMethod, tokenId: String?, issuer: Issuer?, installments: Int) -> Void) -> PaymentVaultViewController {
        
        return PaymentVaultViewController(amount: amount, excludedPaymentTypes: excludedPaymentTypes, excludedPaymentMethods: excludedPaymentMethods, callback:callback)
        
    }
    
    
    

}
