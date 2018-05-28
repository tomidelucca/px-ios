//
//  PXOneTapItemComponentProps.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 16/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXOneTapItemComponentProps {
    let collectorImage: UIImage?
    let title: String?
    let totalAmount: Double
    let amountWithoutDiscount: Double?
    let discountDescription: String?

    init(title: String?, collectorImage: UIImage?, totalAmount: Double, amountWithoutDiscount: Double?, discountDescription: String?) {
        self.collectorImage = collectorImage
        self.title = title
        self.totalAmount = totalAmount
        self.amountWithoutDiscount = amountWithoutDiscount
        self.discountDescription = discountDescription
    }
}
