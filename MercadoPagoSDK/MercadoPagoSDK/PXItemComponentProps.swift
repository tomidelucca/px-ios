//
//  PXItemComponentProps.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 3/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXItemComponentProps : NSObject {
    var imageURL: String?
    var title: String?
    var _description: String?
    var quantity: Int?
    var unitAmount: Double?
    var reviewScreenPreference: ReviewScreenPreference

    init(imageURL: String?, title: String?, description: String?, quantity: Int?, unitAmount: Double?, reviewScreenPreference: ReviewScreenPreference = ReviewScreenPreference()) {
        self.imageURL = imageURL
        self.title = title
        self._description = description
        self.quantity = quantity
        self.unitAmount = unitAmount
        self.reviewScreenPreference = reviewScreenPreference
    }
}
