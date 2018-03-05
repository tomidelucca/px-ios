//
//  PXImageService.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 5/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

open class PXImageService: NSObject {
    
    let bundle = MercadoPago.getBundle()

    open class func getIconImageFor(paymentMethod: PaymentMethod) -> UIImage? {
//        if let paymentMethodImage = MercadoPago.getImage()
        return UIImage()
    }
    
    open class func getCardFormImageFor(paymentMethod: PaymentMethod) -> UIImage? {
        return UIImage()
    }
    
    open class func getImageFor2(paymentMethodOption: PaymentMethodOption) -> UIImage? {
        
        guard !(paymentMethodOption is PXPaymentMethodPlugin) else {
            let plugin = paymentMethodOption as! PXPaymentMethodPlugin
            return plugin.getImage()
        }

        
//        guard !(paymentMethodOption is PaymentOptionDrawable) else {
//            let drawable = paymentMethodOption as! PaymentOptionDrawable
//            return drawable.getImage()
//        }
        
        let path = MercadoPago.getBundle()!.path(forResource: "PaymentMethodSearch", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)
        let pm = dictPM?.value(forKey: paymentMethodOption.getId()) as! NSDictionary
        return MercadoPago.getImage(pm.object(forKey: "image_name") as! String?)
        
//        if let paymentMethod = paymentMethodOption as? PaymentMethod {
//            let path = MercadoPago.getBundle()!.path(forResource: "PaymentMethodSearch", ofType: "plist")
//            let dictPM = NSDictionary(contentsOfFile: path!)
//
//            if let pm = dictPM?.value(forKey: paymentMethod._id) as? NSDictionary {
//                return MercadoPago.getImage(pm.object(forKey: "image_name") as! String?)
//            } else if let pm2 = dictPM?.value(forKey: paymentMethod._id + "_" + paymentMethod.paymentTypeId) as? NSDictionary {
//                return MercadoPago.getImage(pm2.object(forKey: "image_name") as! String?)
//            }
//        }
//
        return nil
    }
    
    open class func getImageFor(paymentMethod: PaymentMethod) -> UIImage? {
        
        guard paymentMethod.paymentTypeId != PaymentTypeId.PAYMENT_METHOD_PLUGIN.rawValue else {
            return paymentMethod.getImageForExtenalPaymentMethod()
        }
        
        let path = MercadoPago.getBundle()!.path(forResource: "PaymentMethodSearch", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)
        
        if let pm = dictPM?.value(forKey: paymentMethod._id) as? NSDictionary {
            return MercadoPago.getImage(pm.object(forKey: "image_name") as! String?)
        } else if let pm2 = dictPM?.value(forKey: paymentMethod._id + "_" + paymentMethod.paymentTypeId) as? NSDictionary {
            return MercadoPago.getImage(pm2.object(forKey: "image_name") as! String?)
        }
        
        return nil
    }
    
}
