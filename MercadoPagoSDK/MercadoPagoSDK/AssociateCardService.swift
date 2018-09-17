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
    
    func associateCardToUser(paymentMethod: PaymentMethod, cardToken: Token, success: @escaping ([String : Any]) -> (), failure: @escaping (Error) -> ()){
        let body = ["card_token_id": cardToken.tokenId]
        guard let jsonData = try? JSONEncoder().encode(body) else{
            return
        }
        let jsonString = String(data: jsonData, encoding: .utf8)
        self.request(uri: uri, params: "access_token=\(accessToken)", body: jsonString, method: "POST", success: { (data) in
            let json = JSONDecoder().decode([String : Any].self, from: data)
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
}
