//
//  PXDiscountParamsConfiguration.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 10/12/2018.
//

import UIKit

@objcMembers
open class PXDiscountParamsConfiguration: NSObject {
    let labels: [String]
    let productId: String

    public init(labels: [String], productId: String) {
        self.labels = labels
        self.productId = productId
    }
}
