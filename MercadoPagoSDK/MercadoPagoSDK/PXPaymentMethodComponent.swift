//
//  PXPaymentMethodComponent.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 24/11/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public class PXPaymentMethodComponent: NSObject, PXComponetizable {
    var props: PXPaymentMethodBodyComponentProps

    init(props: PXPaymentMethodBodyComponentProps) {
       self.props = props
    }
    public func render() -> UIView {
        return PXPaymentMethodBodyComponentRenderer().render(component: self)
    }
}

class PXPaymentMethodBodyComponentProps: NSObject {
    var paymentMethodIcon: UIImage
    var amountTitle: String
    var amountDetail: String?
    var paymentMethodDescription: String?
    var paymentMethodDetail: String?

    init(paymentMethodIcon: UIImage, amountTitle: String, amountDetail: String?, paymentMethodDescription: String?, paymentMethodDetail: String?) {
        self.paymentMethodIcon = paymentMethodIcon
        self.amountTitle = amountTitle
        self.amountDetail = amountDetail
        self.paymentMethodDescription = paymentMethodDescription
        self.paymentMethodDetail = paymentMethodDetail
    }

}
