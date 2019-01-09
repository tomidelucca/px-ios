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
    open var discountToken: Int64?
    open var splitToken: Int64?
    open var splitEnabled: Bool = false
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

    public init(splitAmount: Double, discountToken: Int64?, splitToken: Int64?, defaultSplit: Bool, selectedPayerCostIndex: Int?, payerCosts: [PXPayerCost]?) {
        self.splitAmount = splitAmount
        self.discountToken = discountToken
        self.splitToken = splitToken
        self.splitEnabled = defaultSplit
        self.selectedPayerCostIndex = selectedPayerCostIndex
        self.payerCosts = payerCosts
    }

    public enum PXPayerCostConfiguration: String, CodingKey {
        case selectedPayerCostIndex = "selected_payer_cost_index"
        case payerCost = "payer_costs"
        case splitAmount = "split_amount"
        case discountToken = "discount_token"
        case splitToken = "split_token"
        case defaultSplit = "split_enabled"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXPayerCostConfiguration.self)
        let splitAmount: Double = try container.decodeIfPresent(Double.self, forKey: .splitAmount) ?? 0
        let discountToken: Int64? = try container.decodeIfPresent(Int64.self, forKey: .discountToken)
        let splitToken: Int64? = try container.decodeIfPresent(Int64.self, forKey: .splitToken)
        let defaultSplit: Bool = try container.decodeIfPresent(Bool.self, forKey: .defaultSplit) ?? false
        let payerCosts: [PXPayerCost]? = try container.decodeIfPresent([PXPayerCost].self, forKey: .payerCost)
        let selectedPayerCostIndex: Int? = try container.decodeIfPresent(Int.self, forKey: .selectedPayerCostIndex)
        self.init(splitAmount: splitAmount, discountToken: discountToken, splitToken: splitToken, defaultSplit: defaultSplit, selectedPayerCostIndex: selectedPayerCostIndex, payerCosts: payerCosts)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXPayerCostConfiguration.self)
        try container.encodeIfPresent(self.payerCosts, forKey: .payerCost)
        try container.encodeIfPresent(self.selectedPayerCostIndex, forKey: .selectedPayerCostIndex)
        try container.encodeIfPresent(self.splitAmount, forKey: .splitAmount)
        try container.encodeIfPresent(self.discountToken, forKey: .discountToken)
        try container.encodeIfPresent(self.splitToken, forKey: .splitToken)
        try container.encodeIfPresent(self.splitEnabled, forKey: .defaultSplit)
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
