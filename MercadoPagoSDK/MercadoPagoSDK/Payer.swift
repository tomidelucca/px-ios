//
//  Payer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

/** :nodoc: */
@objcMembers
open class Payer: NSObject {
	internal var email: String!
	internal var payerId: String?
	internal var identification: Identification?
    internal var entityType: EntityType?
    internal var name: String?
    internal var surname: String?
    internal var accessToken: String?

    public init(email: String) {
		self.email = email
	}

    internal func clearCollectedData() {
        self.entityType = nil
        self.identification = nil
        self.name = nil
        self.surname = nil
    }
}

/** :nodoc: */
// MARK: Setters
extension Payer {
    open func setId(payerId: String) {
        self.payerId = payerId
    }

    open func setIdentification(identification: Identification) {
        self.identification = identification
    }

    open func setEntityType(entityType: EntityType) {
        self.entityType = entityType
    }

    open func setFirstName(name: String) {
        self.name = name
    }

    open func setLastName(lastName: String) {
        self.surname = lastName
    }

    internal func setAccessToken(accessToken: String) {
        self.accessToken = accessToken
    }
}

/** :nodoc: */
// MARK: Getters
extension Payer {
    open func getEmail() -> String {
        return email
    }

    open func getId() -> String? {
        return payerId
    }

    open func getIdentification() -> Identification? {
        return identification
    }

    open func getEntityType() -> EntityType? {
        return entityType
    }

    open func getFirstName() -> String? {
        return name
    }

    open func getLastName() -> String? {
        return surname
    }

    internal func getAccessToken() -> String? {
        return accessToken
    }
}

// MarK: JSON
extension Payer {
    internal class func fromJSON(_ json: NSDictionary) -> Payer {
        let payer: Payer = Payer(email: "")

        if let id = JSONHandler.attemptParseToString(json["id"]) {
            payer.payerId  = id
        }

        if let email = JSONHandler.attemptParseToString(json["email"]) {
            payer.email  = email
        }

        if let identificationDic = json["identification"] as? NSDictionary {
            payer.identification = Identification.fromJSON(identificationDic)
        }

        if let entityTypeDic = json["entity_type"] as? NSDictionary {
            payer.entityType = EntityType.fromJSON(entityTypeDic)
        }

        if let name = JSONHandler.attemptParseToString(json["first_name"]) {
            payer.name = name
        }

        if let surname = JSONHandler.attemptParseToString(json["last_name"]) {
            payer.surname = surname
        }

        return payer
    }

    internal func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }

    internal func toJSON() -> [String: Any] {
        let email: Any = self.email == nil ? JSONHandler.null : (self.email!)
        var obj: [String: Any] = [
            "email": email
        ]

        if self.payerId != nil {
            obj["id"] = self.payerId
        }

        if self.identification != nil {
            obj["identification"] = self.identification?.toJSON()
        }

        if let ET = self.entityType {
            obj["entity_type"] = ET.entityTypeId
        }

        if self.name != nil {
            obj["first_name"] = self.name
        }

        if self.surname != nil {
            obj["last_name"] = self.surname
        }

        return obj
    }
}
