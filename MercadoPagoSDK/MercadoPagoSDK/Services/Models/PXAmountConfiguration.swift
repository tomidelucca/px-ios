//
//  PXAmountConfiguration.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 29/11/2018.
//

import UIKit

open class PXAmountConfiguration: NSObject, Codable {
    open var selectedPayerCostIndex: Int?
    open var selectedPayerCost: PXPayerCost? {
        get {
            if let remotePayerCosts = payerCosts, let selectedIndex = selectedPayerCostIndex, remotePayerCosts.indices.contains(selectedIndex) {
                return remotePayerCosts[selectedIndex]
            }
            return nil
        }
    }
    open var payerCosts: [PXPayerCost]?
    open var splitConfiguration: PXSplitConfiguration?
    open var discountToken: Int64?

    public init(selectedPayerCostIndex: Int?, payerCosts: [PXPayerCost]?, splitConfiguration: PXSplitConfiguration?, discountToken: Int64?) {
        self.selectedPayerCostIndex = selectedPayerCostIndex
        self.payerCosts = payerCosts
        self.splitConfiguration = splitConfiguration
        self.discountToken = discountToken
    }

    public enum PXPayerCostConfiguration: String, CodingKey {
        case selectedPayerCostIndex = "selected_payer_cost_index"
        case payerCost = "payer_costs"
        case split
        case discountToken = "discount_token"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXPayerCostConfiguration.self)
        let payerCosts: [PXPayerCost]? = try container.decodeIfPresent([PXPayerCost].self, forKey: .payerCost)
        let selectedPayerCostIndex: Int? = try container.decodeIfPresent(Int.self, forKey: .selectedPayerCostIndex)
        let splitConfiguration: PXSplitConfiguration? = try container.decodeIfPresent(PXSplitConfiguration.self, forKey: .split)
        let discountToken: Int64? = try container.decodeIfPresent(Int64.self, forKey: .discountToken)
        self.init(selectedPayerCostIndex: selectedPayerCostIndex, payerCosts: payerCosts, splitConfiguration: splitConfiguration, discountToken: discountToken)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXPayerCostConfiguration.self)
        try container.encodeIfPresent(self.payerCosts, forKey: .payerCost)
        try container.encodeIfPresent(self.selectedPayerCostIndex, forKey: .selectedPayerCostIndex)
        try container.encodeIfPresent(self.discountToken, forKey: .discountToken)
        try container.encodeIfPresent(self.splitConfiguration, forKey: .split)
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
