//
//  PXDiscount.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/20/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
@objc
open class PXDiscount: NSObject, Codable {
    open var id: String!
    open var name: String?
    open var percentOff: Double
    open var amountOff: Double
    open var couponAmount: Double
    open var currencyId: String?

    @objc
    public init(id: String, name: String?, percentOff: Double, amountOff: Double, couponAmount: Double, currencyId: String?) {
        self.id = id
        self.name = name
        self.percentOff = percentOff
        self.amountOff = amountOff
        self.couponAmount = couponAmount
        self.currencyId = currencyId
    }

    public enum PXDiscountKeys: String, CodingKey {
        case id
        case name
        case percentOff = "percent_off"
        case amountOff = "amount_off"
        case couponAmount = "coupon_amount"
        case currencyId = "currency_id"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXDiscountKeys.self)
        let percentOff: Double = try container.decodeIfPresent(Double.self, forKey: .percentOff) ?? 0
        let amountOff: Double = try container.decodeIfPresent(Double.self, forKey: .amountOff) ?? 0
        let couponAmount: Double = (try container.decodeIfPresent(Double.self, forKey: .couponAmount)) ?? 0
        var id = ""
        do {
            let intId = try container.decodeIfPresent(Int.self, forKey: .id)
            id = (intId?.stringValue)!
        } catch {
            let stringId = try container.decodeIfPresent(String.self, forKey: .id)
            id = stringId!
        }
        let name: String? = try container.decodeIfPresent(String.self, forKey: .name)
        let currencyId: String? = try container.decodeIfPresent(String.self, forKey: .currencyId)

        self.init(id: id, name: name, percentOff: percentOff, amountOff: amountOff, couponAmount: couponAmount, currencyId: currencyId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXDiscountKeys.self)
        try container.encodeIfPresent(self.percentOff, forKey: .percentOff)
        try container.encodeIfPresent(self.amountOff, forKey: .amountOff)
        try container.encodeIfPresent(self.couponAmount, forKey: .couponAmount)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.currencyId, forKey: .currencyId)
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

    open class func fromJSON(data: Data) throws -> PXDiscount {
        return try JSONDecoder().decode(PXDiscount.self, from: data)
    }

}
