//
//  PXSplitConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 08/01/2019.
//

import Foundation
/// :nodoc:
open class PXSplitConfiguration: NSObject, Codable {
    open var splitAmount: Double = 0
    open var paymentMethodId: String = ""
    open var primaryPaymentMethodDiscount: PXDiscount?
    open var secondaryPaymentMethodDiscount: PXDiscount?
    open var splitEnabled: Bool = false
    open var message: String?
    open var selectedPayerCostIndex: Int?
    open var payerCosts: [PXPayerCost]?
    open var selectedPayerCost: PXPayerCost? {
        get {
            if let remotePayerCosts = payerCosts, let selectedIndex = selectedPayerCostIndex, remotePayerCosts.indices.contains(selectedIndex) {
                return remotePayerCosts[selectedIndex]
            }
            return nil
        }
    }

    public init(splitAmount: Double, paymentMethodId: String, primaryDiscount: PXDiscount?, message: String?, secondaryDiscount: PXDiscount?, defaultSplit: Bool, selectedPayerCostIndex: Int?, payerCosts: [PXPayerCost]?) {
        self.splitAmount = splitAmount
        self.paymentMethodId = paymentMethodId
        self.primaryPaymentMethodDiscount = primaryDiscount
        self.message = message
        self.secondaryPaymentMethodDiscount = secondaryDiscount
        self.splitEnabled = defaultSplit
        self.selectedPayerCostIndex = selectedPayerCostIndex
        self.payerCosts = payerCosts
    }

    public enum PXPayerCostConfiguration: String, CodingKey {
        case selectedPayerCostIndex = "selected_payer_cost_index"
        case payerCost = "payer_costs"
        case splitAmount = "amount"
        case primaryDiscount = "primary_payment_method_discount"
        case secondaryDiscount = "secondary_payment_method_discount"
        case defaultSplit = "default_enabled"
        case message
        case paymentMethodId = "secondary_payment_method_id"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXPayerCostConfiguration.self)
        let splitAmount: Double = try container.decodeIfPresent(Double.self, forKey: .splitAmount) ?? 0
        let primaryDiscount: PXDiscount? = try container.decodeIfPresent(PXDiscount.self, forKey: .primaryDiscount)
        let secondaryDiscount: PXDiscount? = try container.decodeIfPresent(PXDiscount.self, forKey: .secondaryDiscount)
        let defaultSplit: Bool = try container.decodeIfPresent(Bool.self, forKey: .defaultSplit) ?? false
        let payerCosts: [PXPayerCost]? = try container.decodeIfPresent([PXPayerCost].self, forKey: .payerCost)
        let selectedPayerCostIndex: Int? = try container.decodeIfPresent(Int.self, forKey: .selectedPayerCostIndex)
        let message: String? = try container.decodeIfPresent(String.self, forKey: .message)
        let paymentMethodId: String = try container.decodeIfPresent(String.self, forKey: .paymentMethodId) ?? ""
        self.init(splitAmount: splitAmount, paymentMethodId: paymentMethodId, primaryDiscount: primaryDiscount, message: message, secondaryDiscount: secondaryDiscount, defaultSplit: defaultSplit, selectedPayerCostIndex: selectedPayerCostIndex, payerCosts: payerCosts)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXPayerCostConfiguration.self)
        try container.encodeIfPresent(self.payerCosts, forKey: .payerCost)
        try container.encodeIfPresent(self.selectedPayerCostIndex, forKey: .selectedPayerCostIndex)
        try container.encodeIfPresent(self.splitAmount, forKey: .splitAmount)
        try container.encodeIfPresent(self.primaryPaymentMethodDiscount, forKey: .primaryDiscount)
        try container.encodeIfPresent(self.secondaryPaymentMethodDiscount, forKey: .secondaryDiscount)
        try container.encodeIfPresent(self.splitEnabled, forKey: .defaultSplit)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encodeIfPresent(self.paymentMethodId, forKey: .paymentMethodId)
    }

    open func toJSONString() throws -> String? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }

    open func toJSON() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
