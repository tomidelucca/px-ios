//
//  PXItemComponent.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 3/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

class PXItemComponent: PXComponentizable {

    public func render() -> UIView {
        return PXItemRenderer().render(self)
    }

    var props: PXItemComponentProps

    init(props: PXItemComponentProps) {
        self.props = props
    }

    func shouldShowTitle() -> Bool {
        return !String.isNullOrEmpty(props.title)
    }

    func getTitle() -> String? {
        return props.title
    }

    func shouldShowDescription() -> Bool {
        return !String.isNullOrEmpty(props.description)
    }

    func getDescription() -> String? {
        return props._description
    }

    func shouldShowQuantity() -> Bool {
        if !props.reviewScreenPreference.shouldShowQuantityRow {
            return false
        }

        if let quantity = props.quantity {
            return quantity > 0
        }
        return false
    }

    func getQuantity() -> String? {
        guard let quantity = props.quantity?.stringValue else  {
            return nil
        }
        return "\(props.reviewScreenPreference.getQuantityTitle()) \(quantity)"
    }

    func shouldShowUnitAmount() -> Bool {
        if !props.reviewScreenPreference.shouldShowAmountTitle {
            return false
        }
        return props.unitAmount != nil
    }

    func getUnitAmountTitle() -> String? {
        return props.reviewScreenPreference.getAmountTitle()
    }

    func getUnitAmountPrice() -> Double? {
        guard let unitAmount = props.unitAmount else {
            return nil
        }
        return unitAmount
    }
}

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
