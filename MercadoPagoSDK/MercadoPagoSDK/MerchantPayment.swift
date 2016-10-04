//
//  MerchantPayment.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class MerchantPayment : NSObject {
    public var issuer : Issuer?
    public var cardTokenId : String!
    public var campaignId : Int = 0
    public var installments : Int = 0
    public var items : [Item]?
    public var merchantAccessToken : String!
    public var paymentMethod : PaymentMethod!
    
    public override init(){
        super.init()
    }
    
    public init(items: [Item], installments: Int, cardIssuer: Issuer?, tokenId: String, paymentMethod: PaymentMethod, campaignId: Int) {
        self.items = items
        self.installments = installments
        self.issuer = cardIssuer
        self.cardTokenId = tokenId
        self.paymentMethod = paymentMethod
        self.campaignId = campaignId
        self.merchantAccessToken = MercadoPagoContext.merchantAccessToken()
    }
    
    public func toJSONString() -> String {
        var obj:[String:AnyObject] = [
            "card_issuer_id": (issuer == nil || self.issuer?._id == 0) ? JSON.null : (self.issuer?._id)!,
            "card_token": self.cardTokenId == nil ? JSON.null : self.cardTokenId!,
            "campaign_id": self.campaignId == 0 ? JSON.null : String(self.campaignId),
            "installments" : self.installments == 0 ? JSON.null : self.installments,
            "merchant_access_token" : self.merchantAccessToken == nil ? JSON.null : self.merchantAccessToken!,
            "payment_method_id" : (self.paymentMethod == nil || self.paymentMethod._id == nil) ? JSON.null : self.paymentMethod._id!
        ]
        
        var itemsJson = ""
        for item in items! {
            itemsJson.appendContentsOf(item.toJSONString())
        }
        obj["items"] = itemsJson
        
        return JSONHandler.jsonCoding(obj)
    }
    
}
