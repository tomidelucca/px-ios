//
//  PXPayerCostConfiguration.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 29/11/2018.
//

import UIKit

open class PXPayerCostConfiguration: NSObject, Codable {
    open var selectedPayerCostIndex: Int
    open var selectedPayerCost: PXPayerCost?
    open var payerCosts: [PXPayerCost]?

    public init(selectedPayerCostIndex: Int, payerCosts: [PXPayerCost]?) {
        self.selectedPayerCostIndex = selectedPayerCostIndex
        self.payerCosts = payerCosts
        if let remotePayerCosts = payerCosts, remotePayerCosts.indices.contains(selectedPayerCostIndex) {
            self.selectedPayerCost = remotePayerCosts[selectedPayerCostIndex]
        }
    }

    public enum PXPayerCostConfiguration: String, CodingKey {
        case selectedPayerCostIndex = "selected_payer_cost_index"
        case payerCost = "payer_costs"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXPayerCostConfiguration.self)
        let payerCosts: [PXPayerCost]? = try container.decodeIfPresent([PXPayerCost].self, forKey: .payerCost)
        let selectedPayerCostIndex: Int = try container.decode(Int.self, forKey: .selectedPayerCostIndex)
        self.init(selectedPayerCostIndex: selectedPayerCostIndex, payerCosts: payerCosts)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXPayerCostConfiguration.self)
        try container.encodeIfPresent(self.payerCosts, forKey: .payerCost)
        try container.encodeIfPresent(self.selectedPayerCostIndex, forKey: .selectedPayerCostIndex)
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

//    open class func fromJSON(data: Data) throws -> PXPayerCostConfiguration {
//        return try JSONDecoder().decode(PXPayerCostConfiguration.self, from: data)
//    }
}
