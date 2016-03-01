//
//  Phone.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Phone : Equatable {
    public var areaCode : String?
    public var number : String?
    
    public class func fromJSON(json : NSDictionary) -> Phone {
        let phone : Phone = Phone()
        phone.areaCode = JSON(json["area_code"]!).asString
        phone.number = JSON(json["number"]!).asString
        return phone
    }
}

public func ==(obj1: Phone, obj2: Phone) -> Bool {
    
    let areEqual =
    obj1.areaCode == obj2.areaCode &&
    obj1.number == obj2.number
    
    return areEqual
}
