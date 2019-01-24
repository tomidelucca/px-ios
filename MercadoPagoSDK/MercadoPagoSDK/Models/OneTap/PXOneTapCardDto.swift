//
//  PXOneTapCardDto.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 23/10/18.
//

import Foundation

/// :nodoc:
open class PXOneTapCardDto: NSObject, Codable {
    open var cardId: String
    open var selectedPayerCostIndex: Int
    open var selectedPayerCost: PXPayerCost?
    open var payerCosts: [PXPayerCost]?
    open var cardUI: PXCardDisplayInfoDto?

    public init(cardId: String, selectedPayerCostIndex: Int, payerCosts: [PXPayerCost]?, cardUI: PXCardDisplayInfoDto?) {
        self.cardId = cardId
        self.selectedPayerCostIndex = selectedPayerCostIndex
        self.payerCosts = payerCosts
        self.cardUI = cardUI
        if let remotePayerCosts = payerCosts, remotePayerCosts.indices.contains(selectedPayerCostIndex) {
            self.selectedPayerCost = remotePayerCosts[selectedPayerCostIndex]
        }
    }

    public enum PXOneTapCardDtoKeys: String, CodingKey {
        case cardId = "id"
        case selectedPayerCostIndex = "selected_payer_cost_index"
        case payerCost = "payer_costs"
        case cardUI = "display_info"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXOneTapCardDtoKeys.self)
        let payerCosts: [PXPayerCost]? = try container.decodeIfPresent([PXPayerCost].self, forKey: .payerCost)
        let cardId: String = try container.decode(String.self, forKey: .cardId)
        let selectedPayerCostIndex: Int = try container.decode(Int.self, forKey: .selectedPayerCostIndex)
        let cardUI: PXCardDisplayInfoDto? = try container.decodeIfPresent(PXCardDisplayInfoDto.self, forKey: .cardUI)
        self.init(cardId: cardId, selectedPayerCostIndex: selectedPayerCostIndex, payerCosts: payerCosts, cardUI: cardUI)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXOneTapCardDtoKeys.self)
        try container.encodeIfPresent(self.payerCosts, forKey: .payerCost)
        try container.encodeIfPresent(self.cardId, forKey: .cardId)
        try container.encodeIfPresent(self.selectedPayerCostIndex, forKey: .selectedPayerCostIndex)
        try container.encodeIfPresent(self.cardUI, forKey: .cardUI)
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

    open class func fromJSON(data: Data) throws -> PXOneTapCardDto {
        return try JSONDecoder().decode(PXOneTapCardDto.self, from: data)
    }
}
