//
//  MPPayment.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 26/4/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class MPPayment: NSObject {
    
    public var email : String!
    public var preferenceId : String!
    public var publicKey : String!
    public var paymentMethodId : String!
    public var installments : Int = 0
    public var issuerId : String?
    public var tokenId : String?
    

    init(email : String, preferenceId : String, publicKey : String, paymentMethodId : String, installments : Int = 0, issuerId : String = "", tokenId : String = "") {
        self.email = email
        self.preferenceId = preferenceId
        self.publicKey = publicKey
        self.paymentMethodId = paymentMethodId
        self.installments = installments
        self.issuerId = issuerId
        self.tokenId = tokenId
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "public_key": self.publicKey,
            "email": self.email,
            "payment_method_id": self.paymentMethodId,
            "pref_id" : self.preferenceId,
            "installments" : self.installments == 0 ? JSON.null : self.installments,
            "issuer_id" : self.issuerId == nil ? JSON.null : self.issuerId!,
            "token_id" : self.tokenId == nil ? JSON.null : self.tokenId!
        ]
        return JSON(obj).toString()
    }
    
}
