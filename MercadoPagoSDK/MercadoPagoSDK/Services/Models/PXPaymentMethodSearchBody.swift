//
//  PXPaymentMethodSearchBody.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/12/2018.
//

import UIKit

class PXPaymentMethodSearchBody: Codable {
    let privateKey: String?
    let email: String?
    let marketplace: String?
    let productId: String?
    let labels: [String]?

    init(privateKey: String?, email: String?, marketplace: String?, productId: String?, labels: [String]?) {
        self.privateKey = privateKey
        self.email = email
        self.marketplace = marketplace
        self.productId = productId
        self.labels = labels
    }

    public enum PXPaymentMethodSearchBodyKeys: String, CodingKey {
        case privateKey
        case email
        case marketplace
        case productId
        case labels
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXPaymentMethodSearchBodyKeys.self)
        if !String.isNullOrEmpty(privateKey) {
            try container.encodeIfPresent(privateKey, forKey: .privateKey)
        }
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.marketplace, forKey: .marketplace)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.labels, forKey: .labels)
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

    open class func fromJSON(data: Data) throws -> PXPaymentMethodSearchBody {
        return try JSONDecoder().decode(PXPaymentMethodSearchBody.self, from: data)
    }
}
