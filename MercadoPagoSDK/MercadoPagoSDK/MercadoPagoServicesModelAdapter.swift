//
//  MercadoPagoServicesModelAdapter.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 10/25/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

internal extension MercadoPagoServicesAdapter {

    internal func getPXSiteFromId(_ siteId: String) -> PXSite {
        let currency = SiteManager.shared.getCurrency()
        let pxSite = PXSite(id: siteId, currencyId: currency.id)
        return pxSite
    }

    internal func getCheckoutPreferenceFromPXCheckoutPreference(_ pxCheckoutPreference: PXCheckoutPreferenceNew) -> PXCheckoutPreference {
        let checkoutPreference = PXCheckoutPreference(siteId: pxCheckoutPreference.siteId ?? "", payerEmail: "", items: [])
        checkoutPreference.preferenceId = pxCheckoutPreference.id
        checkoutPreference.items = pxCheckoutPreference.items!
        checkoutPreference.payer = pxCheckoutPreference.payer
        checkoutPreference.differentialPricing = pxCheckoutPreference.differentialPricing
        checkoutPreference.paymentPreference = getPaymentPreferenceFromPXPaymentPreference(pxCheckoutPreference.paymentPreference)
        checkoutPreference.expirationDateFrom = pxCheckoutPreference.expirationDateFrom ?? Date()
        checkoutPreference.expirationDateTo = pxCheckoutPreference.expirationDateTo ?? Date()
        return checkoutPreference
    }

    internal func getPaymentPreferenceFromPXPaymentPreference(_ pxPaymentPreference: PXPaymentPreference?) -> PaymentPreference {
        let paymentPreference = PaymentPreference()
        if let pxPaymentPreference = pxPaymentPreference {
            paymentPreference.excludedPaymentMethodIds = Set(pxPaymentPreference.excludedPaymentMethodIds ?? [])
            paymentPreference.excludedPaymentTypeIds = Set(pxPaymentPreference.excludedPaymentTypeIds ?? [])
            paymentPreference.defaultPaymentMethodId = pxPaymentPreference.defaultPaymentMethodId
            paymentPreference.maxAcceptedInstallments = pxPaymentPreference.maxAcceptedInstallments != nil ? pxPaymentPreference.maxAcceptedInstallments! : paymentPreference.maxAcceptedInstallments
            paymentPreference.defaultInstallments = pxPaymentPreference.defaultInstallments != nil ? pxPaymentPreference.defaultInstallments! : paymentPreference.defaultInstallments
            paymentPreference.defaultPaymentTypeId = pxPaymentPreference.defaultPaymentTypeId
        }
        return paymentPreference
    }

    internal func getPXCardTokenFromCardToken(_ cardToken: CardToken) -> PXCardToken {
        let pxCardToken = PXCardToken()
        pxCardToken.cardholder = cardToken.cardholder
        pxCardToken.cardNumber = cardToken.cardNumber
        pxCardToken.device = getPXDeviceFromDevice(cardToken.device)
        pxCardToken.expirationMonth = cardToken.expirationMonth
        pxCardToken.expirationYear = cardToken.expirationYear
        pxCardToken.securityCode = cardToken.securityCode
        return pxCardToken
    }

    internal func getPXSavedESCCardTokenFromSavedESCCardToken(_ savedESCCardToken: SavedESCCardToken) -> PXSavedESCCardToken {
        let pxSavedESCCardToken = PXSavedESCCardToken()
        pxSavedESCCardToken.cardId = savedESCCardToken.cardId
        pxSavedESCCardToken.securityCode = savedESCCardToken.securityCode
        pxSavedESCCardToken.device = PXDevice()
        pxSavedESCCardToken.requireEsc = savedESCCardToken.requireESC
        pxSavedESCCardToken.esc = savedESCCardToken.esc
        return pxSavedESCCardToken
    }

    internal func getPXSavedCardTokenFromSavedCardToken(_ savedCardToken: SavedCardToken) -> PXSavedCardToken {
        let pxSavedCardToken = PXSavedCardToken()
        pxSavedCardToken.cardId = savedCardToken.cardId
        pxSavedCardToken.securityCode = savedCardToken.securityCode
        pxSavedCardToken.device = getPXDeviceFromDevice(savedCardToken.device)
        return pxSavedCardToken
    }

    internal func getPXDeviceFromDevice(_ device: Device?) -> PXDevice {
        if let device = device {
            let pxDevice = PXDevice()
            pxDevice.fingerprint = getPXFingerprintFromFingerprint(device.fingerprint)
            return pxDevice
        } else {
            return PXDevice()
        }
    }

    internal func getPXFingerprintFromFingerprint(_ fingerprint: Fingerprint) -> PXFingerprint {
        let pxFingerprint = PXFingerprint()
        return pxFingerprint
    }

    func getStringDateFromDate(_ date: Date) -> String {
        let stringDate = String(describing: date)
        return stringDate
    }

    internal func getEntityTypeFromId(_ entityTypeId: String?) -> EntityType? {
        if let entityTypeId = entityTypeId {
            let entityType = EntityType()
            entityType.entityTypeId = entityTypeId
            entityType.name = ""
            return entityType
        } else {
            return nil
        }
    }
}
