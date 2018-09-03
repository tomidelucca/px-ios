//
//  CheckoutPreference.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit


/**
 Model that represents curl -X OPTIONS "https://api.mercadopago.com/checkout/preferences" | json_pp
 It can be not exactly the same because exists custom configurations for open Preference.
 Some values like: binary mode are not present on API call.
 */
@objcMembers open class PXCheckoutPreference: NSObject {
    internal var preferenceId: String!
    internal var items: [PXItem] = []
    internal var payer: Payer!
    internal var paymentPreference: PaymentPreference = PaymentPreference()
    internal var siteId: String!
    internal var expirationDateFrom: Date?
    internal var expirationDateTo: Date?
    internal var differentialPricing: PXDifferentialPricing?
    private var binaryModeEnabled: Bool = false

    // MARK: Initialization
    /**
     Mandatory init.
     - parameter preferenceId: The preference id that represents the payment information.
     */
    public init(preferenceId: String) {
        self.preferenceId = preferenceId
    }

    /**
     Mandatory init.
     Builder for custom CheckoutPreference construction.
     It should be only used if you are processing the payment
     with a Payment processor. Otherwise you should use the ID constructor.
     - parameter siteId: Preference site.
     - parameter payerEmail: Payer email.
     - parameter items: Items to pay.
     */
    public init(siteId: String, payerEmail: String, items: [PXItem]) {
        self.items = items

        guard let siteId = PXSites(rawValue: siteId)?.rawValue else {
            fatalError("Invalid site id")
        }
        self.siteId = siteId
        self.payer = Payer(email: payerEmail)
    }

    internal func isExpired() -> Bool {
        let date = Date()
        if let expirationDateTo = expirationDateTo {
            return expirationDateTo > date
        }
        return false
    }

    internal func isActive() -> Bool {
        let date = Date()
        if let expirationDateFrom = expirationDateFrom {
            return expirationDateFrom < date
        }
        return true
    }

    internal func hasMultipleItems() -> Bool {
        return items.count > 1
    }

    internal func clearCardId() {
        self.paymentPreference.cardId = nil
    }
}

// MARK: Setters
extension PXCheckoutPreference {
    /**
     Date that indicates when this preference expires.
     If the preference is expired, then the checkout will show an error.
     - parameter expirationDate: Date expiration.
     */
    open func setExpirationDate(_ expirationDate: Date) {
        self.expirationDateTo = expirationDate
    }

    /**
     Date that indicates when this preference start.
     - parameter date: Date active.
     */
    open func setActiveFromDate(_ date: Date) {
        self.expirationDateFrom = date
    }

    /**
     Differential pricing configuration for this preference.
     This object is related with the way the installments are asked.
     - parameter differentialPricing: `PXDifferentialPricing` pricing object.
     */
    open func setDifferentialPricing(differentialPricing: PXDifferentialPricing) {
        self.differentialPricing = differentialPricing
    }

    /**
     Add exclusion payment method id. If you exclude it, it's not going appear as a payment method available on checkout.
     - parameter paymentMethodId: paymentMethodId exclusion id.
     */
    public func addExcludedPaymentMethod(_ paymentMethodId: String) {
        if self.paymentPreference.excludedPaymentMethodIds != nil {
            self.paymentPreference.excludedPaymentMethodIds?.insert(paymentMethodId)
        } else {
            self.paymentPreference.excludedPaymentMethodIds = [paymentMethodId]
        }
    }

    /**
     Add exclusion list by payment method id. If you exclude it, it's not going appear as a payment method available on checkout.
     - parameter paymentMethodIds: paymentMethodId exclusion id.
     */
    public func setExcludedPaymentMethods(_ paymentMethodIds: Set<String>) {
        self.paymentPreference.excludedPaymentMethodIds = paymentMethodIds
    }

    /**
     Add exclusion by payment type
     If you exclude it, it's not going appear as a payment method available on checkout
     - parameter paymentTypeId: paymentTypeId exclusion type
     */
    public func addExcludedPaymentType(_ paymentTypeId: String) {
        if self.paymentPreference.excludedPaymentTypeIds != nil {
            self.paymentPreference.excludedPaymentTypeIds?.insert(paymentTypeId)
        } else {
            self.paymentPreference.excludedPaymentTypeIds = [paymentTypeId]
        }
    }

    /**
     Add exclusion list by payment type
     If you exclude it, it's not going appear as a payment method available on checkout
     - parameter paymentTypeIds: paymentTypeIds exclusion list.
     */
    public func setExcludedPaymentTypes(_ paymentTypeIds: Set<String>) {
        self.paymentPreference.excludedPaymentTypeIds = paymentTypeIds
    }

    /**
     This value limits the amount of installments to be shown by the user.
     - parameter maxInstallments: max installments to be shown
     */
    public func setMaxInstallments(_ maxInstallments: Int) {
        self.paymentPreference.maxAcceptedInstallments = maxInstallments
    }

    /**
     When default installments is not null
     then this value will be forced as installment selected if it matches
     with one provided by the Installments service.
     - parameter defaultInstallments: number of the value to be forced
     */
    public func setDefaultInstallments(_ defaultInstallments: Int) {
        self.paymentPreference.defaultInstallments = defaultInstallments
    }

    /**
     Default paymetMethodId selection.
     WARNING: This is an internal method not intended for public use.
     It is not considered part of the public API.
     */
    public func setDefaultPaymentMethodId(_ paymetMethodId: String) {
        self.paymentPreference.defaultPaymentMethodId = paymetMethodId
    }

    // MARK: MoneyIn
    /**
     Default cardId selection.
     WARNING: This is an internal method not intended for public use.
     It is not considered part of the public API. Only to support Moneyin feature.
     */
    public func setCardId(cardId: String) {
        self.paymentPreference.cardId = cardId
    }
}

// MARK: BinaryMode
extension PXCheckoutPreference {
    /**
     Determinate if binaryMode feature is enabled/disabled.
     */
    open func isBinaryMode() -> Bool {
        return binaryModeEnabled
    }

    /**
     Default value is `FALSE`.
     `TRUE` value processed payment can only be APPROVED or REJECTED.
     Non compatible with PaymentProcessor or off payments methods.
     - parameter isBinaryMode: Binary mode Bool value.
     */
    open func setBinaryMode(isBinaryMode: Bool) -> PXCheckoutPreference {
        self.binaryModeEnabled = isBinaryMode
        return self
    }
}

// MARK: Getters
extension PXCheckoutPreference {
    open func getId() -> String {
        return self.preferenceId
    }

    open func getItems() -> [PXItem]? {
        return items
    }

    open func getSiteId() -> String {
        return self.siteId
    }

    open func getExpirationDate() -> Date? {
        return expirationDateTo
    }

    open func getActiveFromDate() -> Date? {
        return expirationDateFrom
    }

    open func getExcludedPaymentTypesIds() -> Set<String>? {
        return paymentPreference.getExcludedPaymentTypesIds()
    }

    open func getDefaultInstallments() -> Int {
        return paymentPreference.getDefaultInstallments()
    }

    open func getMaxAcceptedInstallments() -> Int {
        return paymentPreference.getMaxAcceptedInstallments()
    }

    open func getExcludedPaymentMethodsIds() -> Set<String>? {
        return paymentPreference.getExcludedPaymentMethodsIds()
    }

    open func getDefaultPaymentMethodId() -> String? {
        return paymentPreference.getDefaultPaymentMethodId()
    }

    open func getTotalAmount() -> Double {
        var amount = 0.0
        for item in self.items {
            amount += (Double(item.quantity) * item.unitPrice)
        }
        return amount
    }
}

// MARK: Internal.
extension PXCheckoutPreference {
    internal func getPayer() -> Payer {
        return payer
    }
}

// MARK: Validation
extension PXCheckoutPreference {
    internal func validate() -> String? {
        if let itemError = itemsValid() {
            return itemError
        }
        if self.payer == nil {
            return "No hay información de payer".localized
        }

        if self.payer.email == nil || self.payer.email?.count == 0 {
            return "Se requiere email de comprador".localized
        }

        if !isActive() {
            return "La preferencia no esta activa.".localized
        }

        if isExpired() {
            return "La preferencia esta expirada".localized
        }
        if self.getTotalAmount() < 0 {
            return "El monto de la compra no es válido".localized
        }
        return nil
    }

    internal func itemsValid() -> String? {
        if Array.isNullOrEmpty(items) {
            return "No hay items".localized
        }

        for item in items {
            if let error = item.validate() {
                return error
            }
        }

        return nil
    }
}
