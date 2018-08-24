//
//  Issuer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

/** :nodoc: */
@objcMembers open class Issuer: NSObject, Cellable {

    var objectType: ObjectTypes = ObjectTypes.issuer
    open var issuerId: String?
    open var name: String?

    internal class func fromJSON(_ json: NSDictionary) -> Issuer {
                let issuer: Issuer = Issuer()

                if let id = json["id"] as? String {
                        issuer.issuerId = JSONHandler.attemptParseToString(id)
                    }

                if let name = JSONHandler.attemptParseToString(json["name"]) {
                        issuer.name = name
                    }

                return issuer
            }

    internal func toJSONString() -> String {
       return JSONHandler.jsonCoding(toJSON())
    }

    internal func toJSON() -> [String: Any] {
        let id: Any = self.issuerId == nil ? JSONHandler.null : self.issuerId!
        let name: Any = self.name == nil ? JSONHandler.null : self.name!
        let obj: [String: Any] = [
            "id": id,
            "name": name
            ]
        return obj
    }
}
