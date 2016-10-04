//
//  Address.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Address : Equatable {
    public var streetName : String?
    public var streetNumber : NSNumber?
    public var zipCode : String?
    

    public init (streetName: String? = nil, streetNumber: NSNumber? = nil, zipCode : String? = nil) {
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.zipCode = zipCode
    }
    
    public class func fromJSON(json : NSDictionary) -> Address {
        let address : Address = Address()
        if let streetName = JSONHandler.attemptParseToString(json["street_name"]) {
            address.streetName = streetName
        }
        if let streetNumber = JSONHandler.attemptParseToString(json["street_number"])!.numberValue {
            address.streetNumber = streetNumber
        }
        if let zipCode = JSONHandler.attemptParseToString(json["zip_code"]) {
            address.zipCode = zipCode
        }
        return address
    }
}

public func ==(obj1: Address, obj2: Address) -> Bool {
    
    let areEqual =
        obj1.streetName == obj2.streetName &&
        obj1.streetNumber == obj2.streetNumber &&
        obj1.zipCode == obj2.zipCode
   
    return areEqual
}
