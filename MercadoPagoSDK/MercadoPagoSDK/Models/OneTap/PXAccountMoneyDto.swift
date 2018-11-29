//
//  PXAccountMoneyDto.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 23/10/18.
//

import Foundation

/// :nodoc:
open class PXAccountMoneyDto: NSObject, Codable {
    open var message: String?
    open var availableBalance: Double = 0
    open var invested: Bool = false
    open var paymentMethod: PXPaymentMethod?

    public init(message: String?, availableBalance: Double, invested: Bool, paymentMethod: PXPaymentMethod?) {
        self.message = message
        self.availableBalance = availableBalance
        self.invested = invested
        self.paymentMethod = paymentMethod
    }

    public enum PXAccountMoneyKeys: String, CodingKey {
        case message
        case availableBalance = "available_balance"
        case invested
        case paymentMethod = "payment_method"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXAccountMoneyKeys.self)
        let message: String? = try container.decodeIfPresent(String.self, forKey: .message)
        let invested: Bool = try container.decode(Bool.self, forKey: .invested)
        let availableBalance: Double = try container.decode(Double.self, forKey: .availableBalance)
        let paymentMethod: PXPaymentMethod? = try container.decodeIfPresent(PXPaymentMethod.self, forKey: .paymentMethod)
        self.init(message: message, availableBalance: availableBalance, invested: invested, paymentMethod: paymentMethod)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXAccountMoneyKeys.self)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encode(self.availableBalance, forKey: .availableBalance)
        try container.encode(self.invested, forKey: .invested)
        try container.encodeIfPresent(self.paymentMethod, forKey: .paymentMethod)
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

    open class func fromJSON(data: Data) throws -> PXAccountMoneyDto {
        return try JSONDecoder().decode(PXAccountMoneyDto.self, from: data)
    }
}
