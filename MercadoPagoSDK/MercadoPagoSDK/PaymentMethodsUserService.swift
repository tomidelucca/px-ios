//
//  PaymentMethodsUserService.swift
//  MercadoPagoSDK
//
//  Created by Diego Flores Domenech on 5/9/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

class PaymentMethodsUserService: MercadoPagoService {
    
    let uri = "/px_mobile_api/payment_methods/cards"
    let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
        super.init(baseURL: PXServicesURLConfigs.MP_API_BASE_URL)
    }
    
    func getPaymentMethods(success: @escaping ([PaymentMethod]) -> (), failure: @escaping (Error) -> ()) {
        self.request(uri: uri, params: "access_token=\(accessToken)", body: nil, method: "GET", success: { (data) in
            let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            if let jsonResult = jsonResult as? [[String: Any]] {
                let paymentMethods = jsonResult.flatMap({return PaymentMethod.fromJSON($0 as NSDictionary)})
                success(paymentMethods)
            } else {
                success([])
            }
        }) { (error) in
            failure(PXError(domain: "mercadopago.sdk.PaymentMethodsUserService.getPaymentMethods", code: ErrorTypes.NO_INTERNET_ERROR, userInfo: [NSLocalizedDescriptionKey: "Hubo un error", NSLocalizedFailureReasonErrorKey: "Verifique su conexión a internet e intente nuevamente"]))
        }
    }

}
