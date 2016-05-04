//
//  PreferenceService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 4/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PreferenceService: MercadoPagoService {
    
    private var MP_PREFERENCE_URI = "/beta/checkout/preferences/"
    
    init(){
        super.init(baseURL: MercadoPagoService.MP_BASE_URL)
    }
    
    internal func getPreference(preferenceId : String, success : (CheckoutPreference) -> Void, failure : (NSError -> Void)){
        let params = "public_key=" + MercadoPagoContext.publicKey()
        self.request(MP_PREFERENCE_URI + preferenceId, params: params, body: nil, method: "GET", success: { (jsonResult) in
                success(CheckoutPreference.fromJSON(jsonResult as! NSDictionary))
            }) { (error) in
                failure(error)
        }
    }

}
