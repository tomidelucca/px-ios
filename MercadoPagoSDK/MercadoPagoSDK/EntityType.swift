//
//  EntityType.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 3/9/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

/** :nodoc: */
@objcMembers open class EntityType: NSObject, Cellable {

    var objectType: ObjectTypes = ObjectTypes.entityType
    open var entityTypeId: String!
    open var name: String!

    internal class func fromJSON(_ json: NSDictionary) -> EntityType {
        let entityType: EntityType = EntityType()

        if let entityTypeId = JSONHandler.attemptParseToString(json["id"]) {
            entityType.entityTypeId = entityTypeId
        }
        if let name = JSONHandler.attemptParseToString(json["name"]) {
            entityType.name = name
        }

        return entityType
    }

    internal func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }

    internal func toJSON() -> [String: Any] {
        let id: Any = self.entityTypeId == nil ? JSONHandler.null : self.entityTypeId!
        let name: Any = self.name == nil ? JSONHandler.null : self.name!
        let obj: [String: Any] = [
            "id": id,
            "name": name
            ]
        return obj
    }
}
