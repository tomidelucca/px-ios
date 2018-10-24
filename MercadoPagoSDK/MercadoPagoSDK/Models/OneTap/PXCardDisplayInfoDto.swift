//
//  PXCardDisplayInfoDto.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 23/10/18.
//

import Foundation

/// :nodoc:
open class PXCardDisplayInfoDto: NSObject, Codable {
    open var expiration: String?
    open var firstSixDigits: String?
    open var lastFourDigits: String?
    open var issuerId: Int?
    open var name: String?
    open var cardPattern: String? //TODO: Check with Andrea. Maybe will be [Int]
    open var color: String?
    open var fontColor: String?

    public init(expiration: String?, firstSixDigits: String?, lastFourDigits: String?, issuerId: Int?, name: String?, cardPattern: String?, color: String?, fontColor: String?) {
        self.expiration = expiration
        self.firstSixDigits = firstSixDigits
        self.lastFourDigits = lastFourDigits
        self.issuerId = issuerId
        self.name = name
        self.cardPattern = cardPattern
        self.color = color
        self.fontColor = fontColor
    }

    public enum PXCardDisplayInfoKeys: String, CodingKey {
        case expiration
        case first_six_digits
        case last_four_digits
        case issuer_id
        case name
        case card_pattern
        case color
        case font_color
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXCardDisplayInfoKeys.self)
        let expiration: String? = try container.decodeIfPresent(String.self, forKey: .expiration)
        let firstSixDigits: String? = try container.decodeIfPresent(String.self, forKey: .first_six_digits)
        let lastFourDigits: String? = try container.decodeIfPresent(String.self, forKey: .last_four_digits)
        let issuerId: Int? = try container.decodeIfPresent(Int.self, forKey: .issuer_id)
        let name: String? = try container.decodeIfPresent(String.self, forKey: .name)
        let cardPattern: String? = try container.decodeIfPresent(String.self, forKey: .card_pattern)
        let color: String? = try container.decodeIfPresent(String.self, forKey: .color)
        let fontColor: String? = try container.decodeIfPresent(String.self, forKey: .font_color)
        self.init(expiration: expiration, firstSixDigits: firstSixDigits, lastFourDigits: lastFourDigits, issuerId: issuerId, name: name, cardPattern: cardPattern, color: color, fontColor: fontColor)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXCardDisplayInfoKeys.self)
        try container.encodeIfPresent(self.expiration, forKey: .expiration)
        try container.encodeIfPresent(self.firstSixDigits, forKey: .first_six_digits)
        try container.encodeIfPresent(self.lastFourDigits, forKey: .last_four_digits)
        try container.encodeIfPresent(self.issuerId, forKey: .issuer_id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.cardPattern, forKey: .card_pattern)
        try container.encodeIfPresent(self.color, forKey: .color)
        try container.encodeIfPresent(self.fontColor, forKey: .font_color)
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

    open class func fromJSON(data: Data) throws -> PXCardDisplayInfoDto {
        return try JSONDecoder().decode(PXCardDisplayInfoDto.self, from: data)
    }
}
