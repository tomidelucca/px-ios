//
//  Item.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

@objcMembers open class Item: NSObject {
    internal var quantity: Int
    internal var unitPrice: Double
    internal var title: String
    internal var itemDescription: String?
    internal var itemId: String?
    internal var categoryId: String?
    internal var pictureUrl: String?

    public init(title: String, quantity: Int, unitPrice: Double) {
        self.title = title
        self.quantity = quantity
        self.unitPrice = unitPrice
    }

    func validate() -> String? {
        if quantity <= 0 {
            return "La cantidad de items no es valida".localized
        }

        return nil
    }

}

// MARK: Setters
extension Item {
    open func setId(id: String) {
        self.itemId = id
    }

    open func setDescription(description: String) {
        self.itemDescription = description
    }

    open func setPictureURL(url: String) {
        self.pictureUrl = url
    }

    open func setCategoryId(categoryId: String) {
        self.categoryId = categoryId
    }
}

// MARK: Getters
extension Item {
    open func getQuantity() -> Int {
        return quantity
    }

    open func getUnitPrice() -> Double {
        return unitPrice
    }

    open func getTitle() -> String {
        return title
    }

    open func getId() -> String? {
        return itemId
    }

    open func getDescription() -> String? {
        return itemDescription
    }

    open func getCategoryId() -> String? {
        return categoryId
    }

    open func getPictureURL() -> String? {
        return pictureUrl
    }
}

extension Item {
    internal class func fromJSON(_ json: NSDictionary) -> Item {
        let item = Item(title: "", quantity: 0, unitPrice: 0)

        item.itemId = JSONHandler.getValue(of: String.self, key: "id", from: json)

        if let quantity = JSONHandler.attemptParseToInt(json["quantity"]) {
            item.quantity = quantity
        }
        if let unitPrice = JSONHandler.attemptParseToDouble(json["unit_price"]) {
            item.unitPrice = unitPrice
        }
        if let title = JSONHandler.attemptParseToString(json["title"]) {
            item.title = title
        }
        if let description = JSONHandler.attemptParseToString(json["description"]) {
            item.itemDescription = description
        }

        if let categoryId = JSONHandler.attemptParseToString(json["category_id"]) {
            item.categoryId = categoryId
        }
        if let pictureUrl = JSONHandler.attemptParseToString(json["picture_url"]) {
            item.pictureUrl = pictureUrl
        }

        return item
    }

    internal func toJSONString() -> String {
        let itemId: Any = (self.itemId == nil) ? JSONHandler.null : self.itemId!
        let title: Any =  (self.title == nil) ? JSONHandler.null : self.title
        let categoryId: Any =  (self.categoryId == nil) ? JSONHandler.null : self.categoryId!
        let pictureUrl: Any =  (self.pictureUrl == nil) ? JSONHandler.null : self.pictureUrl!

        let obj: [String: Any] = [
            "id": itemId,
            "quantity": self.quantity,
            "unit_price": self.unitPrice,
            "title": title,
            "description": self.itemDescription ?? "",
            "category_id": categoryId,
            "picture_url": pictureUrl
        ]
        return JSONHandler.jsonCoding(obj)
    }
}
