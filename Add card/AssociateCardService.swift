//
//  AssociateCardService.swift
//  MercadoPagoSDK
//
//  Created by Diego Flores Domenech on 11/9/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

class AssociateCardService: MercadoPagoService {

    let uri = "/px_mobile_api/cards"
    let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
        super.init(baseURL: PXServicesURLConfigs.MP_API_BASE_URL)
    }
    
    func associateCardToUser(paymentMethod: PXPaymentMethod, cardToken: PXToken, success: @escaping ([String : Any]) -> (), failure: @escaping (Error) -> ()){
        let paymentMethodDict : [String : String] = ["id" : paymentMethod.id]
        let body : [String : Any] = ["card_token_id": cardToken.id, "payment_method": paymentMethodDict]
        let data = NSKeyedArchiver.archivedData(withRootObject: body)
        let jsonString = String(data: data, encoding: .utf8)
        self.request(uri: uri, params: "access_token=\(accessToken)", body: jsonString, method: "POST", success: { (data) in
            let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            if let jsonResult = jsonResult as? [String : Any] {
                success(jsonResult)
            }
        }) { (error) in
            failure(error)
        }
    }
    
}
