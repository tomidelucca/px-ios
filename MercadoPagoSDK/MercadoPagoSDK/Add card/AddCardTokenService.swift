//
//  AddCardTokenService.swift
//  MercadoPagoSDKV4
//
//  Created by Diego Flores Domenech on 26/9/18.
//

import UIKit

class AddCardTokenService: MercadoPagoService {

    let uri = "/v1/card_tokens"
    let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
        super.init(baseURL: PXServicesURLConfigs.MP_API_BASE_URL)
    }
    
    func createToken(cardToken: PXCardToken, success: @escaping (PXToken) -> (), failure: @escaping (PXError) -> ()){
        do {
            self.request(uri: uri, params: "access_token=\(accessToken)", body: (try cardToken.toJSONString()), method: "POST", success: { (data) in
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                if let jsonResult = jsonResult as? [String : Any] {
                    do {
                        let apiException = try PXApiException.fromJSON(data: data)
                        failure(PXError(domain: "mercadopago.sdk.associateCard", code: ErrorTypes.API_EXCEPTION_ERROR, userInfo: jsonResult, apiException: apiException))
                    } catch {
                        let token = try? PXToken.fromJSON(data: data)
                        if let token = token {
                            success(token)
                        }
                    }
                }
            }) { (error) in
                failure(PXError(domain: "mercadopago.sdk.associateCard", code: ErrorTypes.NO_INTERNET_ERROR, userInfo: [NSLocalizedDescriptionKey: "Hubo un error", NSLocalizedFailureReasonErrorKey: "Verifique su conexión a internet e intente nuevamente"]))
            }
        } catch{
            
        }
        
    }

    
}
