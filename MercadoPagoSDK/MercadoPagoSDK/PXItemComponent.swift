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

    func getTitle() -> String? {
        return props.title
    }

    func getDescription() -> String? {
        return props._description
    }

    func getQuantity() -> String? {
        if let quantity = props.quantity?.stringValue {
            return "Cantidad: \(quantity)"
        }
        return nil
    }

    func getUnitAmount() -> String? {
        return "Precio unitario: 20 balbal kalb albsalsba lbla dasdbal asfd,a asdasfa "
    }
}

final class PXItemComponentProps : NSObject {
    var imageURL: String?
    var title: String?
    var _description: String?
    var quantity: Int?
    var unitAmount: Double?


    init(imageURL: String?, title: String?, description: String?, quantity: Int?, unitAmount: Double?) {
        self.imageURL = imageURL
        self.title = title
        self._description = description
        self.quantity = quantity
        self.unitAmount = unitAmount
    }

}
