//
//  PXResourceProvider.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/5/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServices

open class PXResourceProvider: NSObject {
    
    static var error_body_title = "¿Que puedo hacer?".localized
    static var error_body_description_base = "error_body_description_"
    
    static open func getTitleForErrorBody(status: String, statusDetail: String) -> String {
        return error_body_title
    }
    
    static open func getDescriptionForErrorBodyForPENDING_CONTINGENCY() -> String {
        let key = error_body_description_base + PXPayment.StatusDetails.PENDING_CONTINGENCY
        let languageId = MercadoPagoContext.getLanguage()
        if let translation = getTranslation(for: key, languageID: languageId), translation.isNotEmpty {
            return translation
        } else {
            return getTranslation(for: error_body_description_base, languageID: languageId)!
        }
    }
    
    static open func getDescriptionForErrorBody(status: String, statusDetail: String) -> String {
        if status.elementsEqual(PXPayment.Status.PENDING) || status.elementsEqual(PXPayment.Status.IN_PROCESS) {
            if statusDetail.elementsEqual(PXPayment.StatusDetails.PENDING_CONTINGENCY) {
                let key = error_body_description_base + PXPayment.StatusDetails.PENDING_CONTINGENCY
                let languageId = MercadoPagoContext.getLanguage()
                if let translation = getTranslation(for: key, languageID: languageId), translation.isNotEmpty {
                    return translation
                } else {
                    return getTranslation(for: error_body_description_base, languageID: languageId)!
                }
            } else if statusDetail.elementsEqual(PXPayment.StatusDetails.PENDING_REVIEW_MANUAL) {
                let key = error_body_description_base + PXPayment.StatusDetails.PENDING_REVIEW_MANUAL
                let languageId = MercadoPagoContext.getLanguage()
                if let translation = getTranslation(for: key, languageID: languageId), translation.isNotEmpty {
                    return translation
                } else {
                    return getTranslation(for: error_body_description_base, languageID: languageId)!
                }
            }
        } else if status.elementsEqual(PXPayment.Status.REJECTED) {
            if statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_CALL_FOR_AUTHORIZE) {
                return "El teléfono está al dorso de tu tarjeta."
            } else if statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_CARD_DISABLED) {
                return "Usa otro medio de pago o llama a {banco/tarjeta} para activar tu tarjeta.O si prefieres, puedes elegir otro medio de pago."
            } else if statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_INSUFFICIENT_AMOUNT) {
                return "¡No te desanimes! Recárgala en cualquier banco o desde tu banca electrónica e inténtalo de nuevo.\nO si prefieres, puedes elegir otro medio de pago."
            } else if statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_OTHER_REASON) {
                return "Usa otra tarjeta u otro medio de pago."
            } else if statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_BY_BANK) {
                return "Por favor, tente pagar de outra forma."
            } else if statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_INSUFFICIENT_DATA) {
                return "Por favor, tente pagar de outra forma."
            } else if statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_DUPLICATED_PAYMENT) {
                return "Igual no te preocupes que tu pago anterior se efectuó con éxito."
            } else if statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_MAX_ATTEMPTS) {
                return "Como llegaste al límite de intentos con esta tarjeta, usa otro medio de pago."
            } else if statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_HIGH_RISK) {
                return "Usa un medio de pago distinto de tarjeta."
            }
        }
        return ""
    }

    static open func getActionTextForErrorBody(_ paymentMethodName: String?) -> String {
        if let paymentMethodName = paymentMethodName {
            let string =  "Ya hablé con %0 y me autorizó".localized
            return string.replacingOccurrences(of: "%0", with: paymentMethodName)
        }
        return ""
    }
    
    static open func getSecondaryTitleForErrorBody(status: String, statusDetail: String) -> String {
        if status.elementsEqual(PXPayment.Status.REJECTED) && statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_CALL_FOR_AUTHORIZE) {
            return "¿No pudiste autorizarlo?"
        }
        return ""
    }

    static open func getTranslation(for key: String, languageID: String) -> String? {
        let path = MercadoPago.getBundle()!.path(forResource: "PXTranslations", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)
        
        if let keyDict = dictionary?.value(forKey: key) as? NSDictionary {
            if let translation = keyDict.value(forKey: languageID) as? String {
                return translation
            }
        }
        return nil
    }
}
