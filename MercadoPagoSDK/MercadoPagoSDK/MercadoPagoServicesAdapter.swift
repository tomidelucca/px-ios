//
//  MercadoPagoServicesAdapter.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 10/23/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServicesV4

internal class MercadoPagoServicesAdapter {

    let mercadoPagoServices: MercadoPagoServices!

    init(publicKey: String, privateKey: String?) {
        mercadoPagoServices = MercadoPagoServices(merchantPublicKey: publicKey, payerAccessToken: privateKey ?? "", procesingMode: "aggregator")
        mercadoPagoServices.setLanguage(language: Localizator.sharedInstance.getLanguage())
    }

    func getTimeOut() -> TimeInterval {
        // TODO: Get it from services
        return 15.0
    }

    func getCheckoutPreference(checkoutPreferenceId: String, callback : @escaping (CheckoutPreference) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        mercadoPagoServices.getCheckoutPreference(checkoutPreferenceId: checkoutPreferenceId, callback: { [weak self] (pxCheckoutPreference) in
            guard let strongSelf = self, let siteId = pxCheckoutPreference.siteId else {
                // TODO: faltal error?
                return
            }
            SiteManager.shared.setSite(siteId: siteId)
            let checkoutPreference = strongSelf.getCheckoutPreferenceFromPXCheckoutPreference(pxCheckoutPreference)
            callback(checkoutPreference)
            }, failure: failure)
    }

    func getInstructions(paymentId: String, paymentTypeId: String, callback : @escaping (InstructionsInfo) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        let int64PaymentId = Int64(paymentId) //TODO: FIX

        mercadoPagoServices.getInstructions(paymentId: int64PaymentId!, paymentTypeId: paymentTypeId, callback: { [weak self] (pxInstructions) in
            guard let strongSelf = self else {
                return
            }

            let instructionsInfo = strongSelf.getInstructionsInfoFromPXInstructions(pxInstructions)
            callback(instructionsInfo)
            }, failure: failure)
    }

    typealias PaymentSearchExclusions = (excludedPaymentTypesIds: Set<String>?, excludedPaymentMethodsIds: Set<String>?)
    typealias PaymentSearchOneTapInfo = (cardsWithEsc: [String]?, supportedPlugins: [String]?)
    typealias ExtraParams = (defaultPaymentMethod: String?, differentialPricingId: String?)

    func getPaymentMethodSearch(amount: Double, exclusions: PaymentSearchExclusions, oneTapInfo: PaymentSearchOneTapInfo, payer: PXPayer, site: String, extraParams: ExtraParams?, callback : @escaping (PaymentMethodSearch) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        payer.setAccessToken(accessToken: mercadoPagoServices.payerAccessToken)

        let pxSite = getPXSiteFromId(site)

        let accountMoneyAvailable: Bool = false // TODO: This is temporary. (Warning: Until AM First Class Member)

        var excludedPaymentTypesIds = exclusions.excludedPaymentTypesIds
        if !accountMoneyAvailable {
            if excludedPaymentTypesIds != nil {
                excludedPaymentTypesIds?.insert("account_money")
            } else {
                excludedPaymentTypesIds = ["account_money"]
            }
        }

        mercadoPagoServices.getPaymentMethodSearch(amount: amount, excludedPaymentTypesIds: exclusions.excludedPaymentTypesIds, excludedPaymentMethodsIds: exclusions.excludedPaymentMethodsIds, cardsWithEsc: oneTapInfo.cardsWithEsc, supportedPlugins: oneTapInfo.supportedPlugins, defaultPaymentMethod: extraParams?.defaultPaymentMethod, payer: payer, site: pxSite, differentialPricingId: extraParams?.differentialPricingId, callback: {  [weak self] (pxPaymentMethodSearch) in
                guard let strongSelf = self else {
                    return
                }
                let paymentMethodSearch = strongSelf.getPaymentMethodSearchFromPXPaymentMethodSearch(pxPaymentMethodSearch)
                callback(paymentMethodSearch)
            }, failure: failure)
    }

    func createPayment(url: String, uri: String, transactionId: String? = nil, paymentData: NSDictionary, query: [String: String]? = nil, callback : @escaping (Payment) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        mercadoPagoServices.createPayment(url: url, uri: uri, transactionId: transactionId, paymentData: paymentData, query: query, callback: { [weak self] (pxPayment) in
            guard let strongSelf = self else {
                return
            }
            let payment = strongSelf.getPaymentFromPXPayment(pxPayment)
            callback(payment)
            }, failure: failure)
    }

    func createToken(cardToken: CardToken, callback : @escaping (PXToken) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        let pxCardToken = getPXCardTokenFromCardToken(cardToken)

        mercadoPagoServices.createToken(cardToken: pxCardToken, callback: { [weak self] (pxToken) in
            guard let strongSelf = self else {
                return
            }
                callback(pxToken)
            }, failure: failure)
    }

    func createToken(savedESCCardToken: SavedESCCardToken, callback : @escaping (PXToken) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        let pxSavedESCCardToken = getPXSavedESCCardTokenFromSavedESCCardToken(savedESCCardToken)

        mercadoPagoServices.createToken(savedESCCardToken: pxSavedESCCardToken, callback: { [weak self] (pxToken) in
            guard let strongSelf = self else {
                return
            }
                callback(pxToken)
            }, failure: failure)
    }

    func createToken(savedCardToken: SavedCardToken, callback : @escaping (PXToken) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        let pxSavedCardToken = getPXSavedCardTokenFromSavedCardToken(savedCardToken)

        mercadoPagoServices.createToken(savedCardToken: pxSavedCardToken, callback: { [weak self] (pxToken) in
            guard let strongSelf = self else {
                return
            }
                callback(pxToken)
            }, failure: failure)
    }

    func createToken(cardTokenJSON: String, callback : @escaping (PXToken) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        mercadoPagoServices.createToken(cardTokenJSON: cardTokenJSON, callback: { [weak self] (pxToken) in
            guard let strongSelf = self else {
                return
            }
                callback(pxToken)
            }, failure: failure)
    }

    func cloneToken(tokenId: String, securityCode: String, callback : @escaping (PXToken) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        mercadoPagoServices.cloneToken(tokenId: tokenId, securityCode: securityCode, callback: { [weak self] (pxToken) in
            guard let strongSelf = self else {
                return
            }
                callback(pxToken)
            }, failure: failure)
    }

    func getBankDeals(callback : @escaping ([PXBankDeal]) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        mercadoPagoServices.getBankDeals(callback: callback, failure: failure)
    }

    func getIdentificationTypes(callback: @escaping ([PXIdentificationType]) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        mercadoPagoServices.getIdentificationTypes(callback: { [weak self] (pxIdentificationTypes) in
            guard let strongSelf = self else {
                return
            }
            callback(pxIdentificationTypes)
            }, failure: failure)
    }

    func getCampaigns(payerEmail: String?, callback: @escaping ([PXCampaign]) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        mercadoPagoServices.getCampaigns(payerEmail: payerEmail, callback: callback, failure: failure)
    }

    func getCodeDiscount(amount: Double, payerEmail: String, couponCode: String?, callback: @escaping (PXDiscount?) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        mercadoPagoServices.getCodeDiscount(amount: amount, payerEmail: payerEmail, couponCode: couponCode, discountAdditionalInfo: nil, callback: { (pxDiscount) in
                callback(pxDiscount)
            }, failure: failure)
    }

    func getDirectDiscount(amount: Double, payerEmail: String, callback: @escaping (PXDiscount?) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {
        getCodeDiscount(amount: amount, payerEmail: payerEmail, couponCode: nil, callback: callback, failure: failure)
    }

    open func getInstallments(bin: String?, amount: Double, issuer: PXIssuer?, paymentMethodId: String, differentialPricingId: String?, callback: @escaping ([PXInstallment]) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        mercadoPagoServices.getInstallments(bin: bin, amount: amount, issuerId: issuer?.id, paymentMethodId: paymentMethodId, differentialPricingId: differentialPricingId, callback: { [weak self] (pxInstallments) in
            guard let strongSelf = self else {
                return
            }

            if let installment = pxInstallments.first, !installment.payerCosts.isEmpty {
                callback(pxInstallments)
            } else {
                failure(strongSelf.createSerializationError(requestOrigin: ApiUtil.RequestOrigin.GET_INSTALLMENTS))
            }
            }, failure: failure)
    }

    func getIssuers(paymentMethodId: String, bin: String? = nil, callback: @escaping ([PXIssuer]) -> Void, failure: @escaping ((_ error: NSError) -> Void)) {

        mercadoPagoServices.getIssuers(paymentMethodId: paymentMethodId, bin: bin, callback: { [weak self] (pxIssuers) in
            guard let strongSelf = self else {
                return
            }
            callback(pxIssuers)
            }, failure: failure)
    }

    func createSerializationError(requestOrigin: ApiUtil.RequestOrigin) -> NSError {
        #if DEBUG
            print("--REQUEST_ERROR: Cannot serlialize data in \(requestOrigin.rawValue)\n")
        #endif

        return NSError(domain: "com.mercadopago.sdk", code: NSURLErrorCannotDecodeContentData, userInfo: [NSLocalizedDescriptionKey: "Hubo un error"])
    }
}
