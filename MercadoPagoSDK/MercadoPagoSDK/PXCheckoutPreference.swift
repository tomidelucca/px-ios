//
//  CheckoutPreference.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

@objcMembers open class PXCheckoutPreference: NSObject {
    internal var preferenceId: String!
    internal var items: [Item] = []
    internal var payer: Payer!
    internal var paymentPreference: PaymentPreference = PaymentPreference()
    internal var siteId: String!
    internal var expirationDateFrom: Date?
    internal var expirationDateTo: Date?
    internal var differentialPricing: PXDifferentialPricing?
    private var binaryModeEnabled: Bool = false

    public init(preferenceId: String) {
        self.preferenceId = preferenceId
    }

    public init(siteId: String, payerEmail: String, items: [Item]) {
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
        if self.paymentPreference.excludedPaymentMethodIds != nil {
            self.paymentPreference.excludedPaymentMethodIds?.insert(paymentMethodId)
        } else {
            self.paymentPreference.excludedPaymentMethodIds = [paymentMethodId]
        }
    }
    public func setExcludedPaymentMethods(_ paymentMethodIds: Set<String>) {
        self.paymentPreference.excludedPaymentMethodIds = paymentMethodIds
    }

    public func addExcludedPaymentType(_ paymentTypeId: String) {
        if self.paymentPreference.excludedPaymentTypeIds != nil {
            self.paymentPreference.excludedPaymentTypeIds?.insert(paymentTypeId)
        } else {
            self.paymentPreference.excludedPaymentTypeIds = [paymentTypeId]
        }
    }

    public func setExcludedPaymentTypes(_ paymentTypeIds: Set<String>) {
        self.paymentPreference.excludedPaymentTypeIds = paymentTypeIds
    }

    public func setMaxInstallments(_ maxInstallments: Int) {
        self.paymentPreference.maxAcceptedInstallments = maxInstallments
    }

    public func setDefaultInstallments(_ defaultInstallments: Int) {
        self.paymentPreference.defaultInstallments = defaultInstallments
    }

    public func setDefaultPaymentMethodId(_ paymetMethodId: String) {
        self.paymentPreference.defaultPaymentMethodId = paymetMethodId
    }
}

// MARK: Getters
extension PXCheckoutPreference {

    open func getId() -> String {
        return self.preferenceId
    }

    open func getItems() -> [Item]? {
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
