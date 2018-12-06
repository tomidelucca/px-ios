//
//  PXPaymentMethodSearch.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/20/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
/// :nodoc:
open class PXPaymentMethodSearch: NSObject, Codable {
    open var paymentMethodSearchItem: [PXPaymentMethodSearchItem] = []
    open var customOptionSearchItems: [PXCustomOptionSearchItem] = []
    open var paymentMethods: [PXPaymentMethod] = []
    open var cards: [PXCard]?
    open var defaultOption: PXPaymentMethodSearchItem?
    open var expressCho: [PXOneTapDto]?
    open var accountMoney: PXAccountMoneyDto?

    public init(paymentMethodSearchItem: [PXPaymentMethodSearchItem], customOptionSearchItems: [PXCustomOptionSearchItem], paymentMethods: [PXPaymentMethod], cards: [PXCard]?, defaultOption: PXPaymentMethodSearchItem?, oneTap: PXOneTapItem?, expressCho: [PXOneTapDto]?, aMoney: PXAccountMoneyDto?) {
        self.paymentMethodSearchItem = paymentMethodSearchItem
        self.customOptionSearchItems = customOptionSearchItems
        self.paymentMethods = paymentMethods
        self.cards = cards
        self.defaultOption = defaultOption
        self.expressCho = expressCho
        self.accountMoney = aMoney
        super.init()
        self.populateOneTap()
    }

    public enum PXPaymentMethodSearchKeys: String, CodingKey {
        case paymentMethodSearchItem = "groups"
        case customOptionSearchItems = "custom_options"
        case paymentMethods = "payment_methods"
        case cards
        case defaultOption = "default_option"
        case expressCho = "express"
        case accountMoney = "account_money"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXPaymentMethodSearchKeys.self)
        let paymentMethodSearchItem: [PXPaymentMethodSearchItem] = try container.decodeIfPresent([PXPaymentMethodSearchItem].self, forKey: .paymentMethodSearchItem) ?? []
        let customOptionSearchItems: [PXCustomOptionSearchItem] = try container.decodeIfPresent([PXCustomOptionSearchItem].self, forKey: .customOptionSearchItems) ?? []
        let paymentMethods: [PXPaymentMethod] = try container.decodeIfPresent([PXPaymentMethod].self, forKey: .paymentMethods) ?? []
        let cards: [PXCard]? = try container.decodeIfPresent([PXCard].self, forKey: .cards)
        let defaultOption: PXPaymentMethodSearchItem? = try container.decodeIfPresent(PXPaymentMethodSearchItem.self, forKey: .defaultOption)
        let expressCho: [PXOneTapDto]? = try container.decodeIfPresent([PXOneTapDto].self, forKey: .expressCho)
        let aMoney: PXAccountMoneyDto? = try container.decodeIfPresent(PXAccountMoneyDto.self, forKey: .accountMoney)

        self.init(paymentMethodSearchItem: paymentMethodSearchItem, customOptionSearchItems: customOptionSearchItems, paymentMethods: paymentMethods, cards: cards, defaultOption: defaultOption, oneTap: nil, expressCho: expressCho, aMoney: aMoney)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXPaymentMethodSearchKeys.self)
        try container.encodeIfPresent(self.paymentMethodSearchItem, forKey: .paymentMethodSearchItem)
        try container.encodeIfPresent(self.customOptionSearchItems, forKey: .customOptionSearchItems)
        try container.encodeIfPresent(self.paymentMethods, forKey: .paymentMethods)
        try container.encodeIfPresent(self.cards, forKey: .cards)
        try container.encodeIfPresent(self.defaultOption, forKey: .defaultOption)
        try container.encodeIfPresent(self.expressCho, forKey: .expressCho)
        try container.encodeIfPresent(self.accountMoney, forKey: .accountMoney)
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

    open class func fromJSON(data: Data) throws -> PXPaymentMethodSearch {
        return try JSONDecoder().decode(PXPaymentMethodSearch.self, from: data)
    }
}


extension PXPaymentMethodSearch {
    private func populateOneTap() {
        if let expressNodes = expressCho {
            for expressNode in expressNodes {
                expressNode.setAccountMoneyNode(accountMoney)
            }
        }
    }
}
