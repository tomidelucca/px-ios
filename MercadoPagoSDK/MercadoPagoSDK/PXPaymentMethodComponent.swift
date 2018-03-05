//
//  PXPaymentMethodComponent.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 24/11/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public class PXPaymentMethodComponent: NSObject, PXComponentizable {
    
    var props: PXPaymentMethodProps

    init(props: PXPaymentMethodProps) {
       self.props = props
    }

    func getPaymentMethodIconComponent() -> PXPaymentMethodIconComponent {
        let paymentMethodIconProps = PXPaymentMethodIconProps(paymentMethodIcon: self.props.paymentMethodIcon)
        let paymentMethodIconComponent = PXPaymentMethodIconComponent(props: paymentMethodIconProps)
        return paymentMethodIconComponent
    }

    public func render() -> UIView {
        return PXPaymentMethodComponentRenderer().render(component: self)
    }
}

class PXPaymentMethodProps: NSObject {
    
    var paymentMethodIcon: UIImage?
    var title: String
    var subtitle: String?
    var descriptionTitle: String?
    var descriptionDetail: String?
    var disclaimer: String?
    var action: PXComponentAction?

    public init(paymentMethodIcon: UIImage?, title: String, subtitle: String?, descriptionTitle: String?, descriptionDetail: String?, disclaimer: String?, action: PXComponentAction? = nil) {
        self.paymentMethodIcon = paymentMethodIcon
        self.title = title
        self.subtitle = subtitle
        self.descriptionTitle = descriptionTitle
        self.descriptionDetail = descriptionDetail
        self.disclaimer = disclaimer
        self.action = action
    }
}
