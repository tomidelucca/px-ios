//
//  PaymentMethodSearchService.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

internal class PaymentMethodSearchService: MercadoPagoService {

    let merchantPublicKey: String!
    let payerAccessToken: String?
    let processingMode: String!

    init (baseURL: String, merchantPublicKey: String, payerAccessToken: String? = nil, processingMode: String) {
        self.merchantPublicKey = merchantPublicKey
        self.payerAccessToken = payerAccessToken
        self.processingMode = processingMode
        super.init(baseURL: baseURL)
    }

    internal func getPaymentMethods(_ amount: Double, customerEmail: String? = nil, customerId: String? = nil, defaultPaymenMethodId: String?, excludedPaymentTypeIds: [String], excludedPaymentMethodIds: [String], cardsWithEsc: [String]?, supportedPlugins: [String]?, site: PXSite, payer: PXPayer, language: String, differentialPricingId: String?, success: @escaping (_ paymentMethodSearch: PXPaymentMethodSearch) -> Void, failure: @escaping ((_ error: PXError) -> Void)) {

        var params =  MercadoPagoServices.getParamsPublicKey(merchantPublicKey)

        params.paramsAppend(key: ApiParams.AMOUNT, value: String(amount))

        let newExcludedPaymentTypesIds = excludedPaymentTypeIds

        if newExcludedPaymentTypesIds.count > 0 {
            let excludedPaymentTypesParams = newExcludedPaymentTypesIds.map({$0}).joined(separator: ",")
            params.paramsAppend(key: ApiParams.EXCLUDED_PAYMET_TYPES, value: String(excludedPaymentTypesParams).trimSpaces())
        }

        if excludedPaymentMethodIds.count > 0 {
            let excludedPaymentMethodsParams = excludedPaymentMethodIds.joined(separator: ",")
            params.paramsAppend(key: ApiParams.EXCLUDED_PAYMENT_METHOD, value: excludedPaymentMethodsParams.trimSpaces())
        }

        if let defaultPaymenMethodId = defaultPaymenMethodId {
            params.paramsAppend(key: ApiParams.DEFAULT_PAYMENT_METHOD, value: defaultPaymenMethodId.trimSpaces())
        }

        params.paramsAppend(key: ApiParams.EMAIL, value: customerEmail)
        params.paramsAppend(key: ApiParams.CUSTOMER_ID, value: customerId)
        params.paramsAppend(key: ApiParams.SITE_ID, value: site.id)
        params.paramsAppend(key: ApiParams.API_VERSION, value: PXServicesURLConfigs.API_VERSION)
        params.paramsAppend(key: ApiParams.PROCESSING_MODE, value: processingMode)
        params.paramsAppend(key: ApiParams.DIFFERENTIAL_PRICING_ID, value: differentialPricingId)

        if let cardsWithEscParams = cardsWithEsc?.map({$0}).joined(separator: ",") {
            params.paramsAppend(key: "cards_esc", value: cardsWithEscParams)
        }

        if let supportedPluginsParams = supportedPlugins?.map({$0}).joined(separator: ",") {
            params.paramsAppend(key: "support_plugins", value: supportedPluginsParams)
        }

        let groupsPayerBody = try? payer.toJSON()

        let headers = ["Accept-Language": language]

        self.request(uri: PXServicesURLConfigs.MP_SEARCH_PAYMENTS_URI, params: params, body: groupsPayerBody, method: HTTPMethod.post, headers: headers, cache: false, success: { (data) -> Void in
            do {
                let dataMock = "{\"default_option\":null,\"custom_options\":[],\"groups\":[{\"children\":[],\"children_header\":null,\"comment\":null,\"description\":\"Boleto Bancário\",\"id\":\"bolbradesco\",\"show_icon\":true,\"type\":\"payment_method\"},{\"children\":[],\"children_header\":null,\"comment\":null,\"description\":\"Pagamento na lotérica sem boleto\",\"id\":\"pec\",\"show_icon\":true,\"type\":\"payment_method\"}],\"payment_methods\":[{\"id\":\"pec\",\"name\":\"Pagamento na lotérica sem boleto\",\"payment_type_id\":\"ticket\",\"status\":\"active\",\"secure_thumbnail\":\"https://www.mercadopago.com/org-img/MP3/API/logos/pec.gif\",\"thumbnail\":\"http://img.mlstatic.com/org-img/MP3/API/logos/pec.gif\",\"deferred_capture\":\"supported\",\"settings\":[],\"additional_info_needed\":[],\"min_allowed_amount\":4,\"max_allowed_amount\":2000,\"accreditation_time\":1440,\"financial_institutions\":[],\"processing_modes\":[\"aggregator\"]},{\"id\":\"bolbradesco\",\"name\":\"Boleto\",\"payment_type_id\":\"ticket\",\"status\":\"active\",\"secure_thumbnail\":\"https://www.mercadopago.com/org-img/MP3/API/logos/bolbradesco.gif\",\"thumbnail\":\"http://img.mlstatic.com/org-img/MP3/API/logos/bolbradesco.gif\",\"deferred_capture\":\"does_not_apply\",\"settings\":[],\"additional_info_needed\":[\"bolbradesco_name\",\"bolbradesco_identification_type\",\"bolbradesco_identification_number\"],\"min_allowed_amount\":4,\"max_allowed_amount\":15000,\"accreditation_time\":1440,\"financial_institutions\":[],\"processing_modes\":[\"aggregator\"]}],\"cards\":[]}".data(using: .utf8)

            let jsonResult = try JSONSerialization.jsonObject(with: dataMock!, options: JSONSerialization.ReadingOptions.allowFragments)
            if let paymentSearchDic = jsonResult as? NSDictionary {
                if paymentSearchDic["error"] != nil {
                    let apiException = try PXApiException.fromJSON(data: dataMock!)
                    failure(PXError(domain: "mercadopago.sdk.PaymentMethodSearchService.getPaymentMethods", code: ErrorTypes.API_EXCEPTION_ERROR, userInfo: [NSLocalizedDescriptionKey: "Hubo un error", NSLocalizedFailureReasonErrorKey: "No se ha podido obtener los métodos de pago"], apiException: apiException))
                } else {

                    if paymentSearchDic.allKeys.count > 0 {
                        let paymentSearch = try PXPaymentMethodSearch.fromJSON(data: dataMock!)
                        success(paymentSearch)
                    } else {
                        failure(PXError(domain: "mercadopago.sdk.PaymentMethodSearchService.getPaymentMethods", code: ErrorTypes.API_UNKNOWN_ERROR, userInfo: [NSLocalizedDescriptionKey: "Hubo un error", NSLocalizedFailureReasonErrorKey: "No se ha podido obtener los métodos de pago"]))
                    }
                }
                }
            } catch {
                failure(PXError(domain: "mercadopago.sdk.PaymentMethodSearchService.getPaymentMethods", code: ErrorTypes.API_UNKNOWN_ERROR, userInfo: [NSLocalizedDescriptionKey: "Hubo un error", NSLocalizedFailureReasonErrorKey: "No se ha podido obtener los métodos de pago"]))
            }

        }, failure: { (error) -> Void in
            failure(PXError(domain: "mercadopago.sdk.PaymentMethodSearchService.getPaymentMethods", code: ErrorTypes.NO_INTERNET_ERROR, userInfo: [NSLocalizedDescriptionKey: "Hubo un error", NSLocalizedFailureReasonErrorKey: "Verifique su conexión a internet e intente nuevamente"]))
        })
    }

}
