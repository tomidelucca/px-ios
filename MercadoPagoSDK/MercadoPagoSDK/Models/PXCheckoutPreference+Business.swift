//
//  PXCheckoutPreference+Business.swift
//  MercadoPagoSDKV4
//
//  Created by Eden Torres on 04/09/2018.
//

import Foundation
extension PXCheckoutPreference {
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
        self.paymentPreference?.cardId = nil
    }
}

// MARK: Setters
extension PXCheckoutPreference {

    open func setExpirationDate(_ expirationDate: Date) {
        self.expirationDateTo = expirationDate
    }

    open func setActiveFromDate(_ date: Date) {
        self.expirationDateFrom = date
    }

    open func setDifferentialPricing(differentialPricing: PXDifferentialPricing) {
        self.differentialPricing = differentialPricing
    }

    public func addExcludedPaymentMethod(_ paymentMethodId: String) {
        guard let paymentPreference = paymentPreference else {
            return
        }
        paymentPreference.excludedPaymentMethodIds.append(paymentMethodId)
    }
    public func setExcludedPaymentMethods(_ paymentMethodIds: [String]) {
        self.paymentPreference?.excludedPaymentMethodIds = paymentMethodIds
    }

    public func addExcludedPaymentType(_ paymentTypeId: String) {
        guard let paymentPreference = paymentPreference else {
            return
        }
        paymentPreference.excludedPaymentMethodIds.append(paymentTypeId)
    }

    public func setExcludedPaymentTypes(_ paymentTypeIds: [String]) {
        self.paymentPreference?.excludedPaymentTypeIds = paymentTypeIds
    }

    public func setMaxInstallments(_ maxInstallments: Int) {
        self.paymentPreference?.maxAcceptedInstallments = maxInstallments
    }

    public func setDefaultInstallments(_ defaultInstallments: Int) {
        self.paymentPreference?.defaultInstallments = defaultInstallments
    }

    public func setDefaultPaymentMethodId(_ paymetMethodId: String) {
        self.paymentPreference?.defaultPaymentMethodId = paymetMethodId
    }

    /// :nodoc:
    public func setCardId(cardId: String) {
        self.paymentPreference?.cardId = cardId
    }
}

// MARK: Getters
extension PXCheckoutPreference {

    open func getId() -> String {
        return self.id
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

    open func getExcludedPaymentTypesIds() -> [String] {
        return paymentPreference?.getExcludedPaymentTypesIds() ?? []
    }

    open func getDefaultInstallments() -> Int {
        return paymentPreference?.getDefaultInstallments() ?? 0
    }

    open func getMaxAcceptedInstallments() -> Int {
        return paymentPreference?.getMaxAcceptedInstallments() ?? 0
    }

    open func getExcludedPaymentMethodsIds() -> [String] {
        return paymentPreference?.getExcludedPaymentMethodsIds() ?? []
    }

    open func getDefaultPaymentMethodId() -> String? {
        return paymentPreference?.getDefaultPaymentMethodId()
    }

    open func getTotalAmount() -> Double {
        var amount = 0.0
        for item in self.items {
            amount += (Double(item.quantity) * item.unitPrice)
        }
        return amount
    }

    internal func getPayer() -> PXPayer {
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

        if String.isNullOrEmpty(payer.email) {
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

// MARK: BinaryMode
extension PXCheckoutPreference {
    open func isBinaryMode() -> Bool {
        return binaryModeEnabled
    }

    open func setBinaryMode(isBinaryMode: Bool) -> PXCheckoutPreference {
        self.binaryModeEnabled = isBinaryMode
        return self
    }
}
