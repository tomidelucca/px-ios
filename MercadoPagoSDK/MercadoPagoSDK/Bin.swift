//
//  Bin.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Bin : Equatable {
    public var exclusionPattern : String!
    public var installmentsPattern : String!
    public var pattern : String!
    

    public class func fromJSON(json : NSDictionary) -> Bin {
        let bin : Bin = Bin()
        bin.exclusionPattern = JSON(json["exclusion_pattern"]!).asString
        bin.installmentsPattern = JSON(json["installments_pattern"]!).asString
        bin.pattern = JSON(json["pattern"]!).asString
        return bin
    }
}


public func ==(obj1: Bin, obj2: Bin) -> Bool {
    
    let areEqual =
        obj1.exclusionPattern == obj2.exclusionPattern &&
        obj1.installmentsPattern == obj2.installmentsPattern &&
        obj1.pattern == obj2.pattern
    
    return areEqual
}