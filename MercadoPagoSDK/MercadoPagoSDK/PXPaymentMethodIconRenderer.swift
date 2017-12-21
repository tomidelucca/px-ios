//
//  PXPaymentMethodIconRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/21/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXPaymentMethodIconRenderer: NSObject {
    
    func render(component: PXPaymentMethodIconComponent) -> PXPaymentMethodIconView {
        let pmIconView = PXPaymentMethodIconView()
        pmIconView.layer.borderWidth = 2
        pmIconView.translatesAutoresizingMaskIntoConstraints = false
        let background = UIImageView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.image = MercadoPago.getImage("empty")
        pmIconView.paymentMethodIconBackground = background
        pmIconView.addSubview(pmIconView.paymentMethodIconBackground!)
        PXLayout.matchWidth(ofView: pmIconView.paymentMethodIconBackground!).isActive = true
        PXLayout.matchHeight(ofView: pmIconView.paymentMethodIconBackground!).isActive = true
        PXLayout.centerVertically(view: background).isActive = true
        PXLayout.centerHorizontally(view: background).isActive = true
        
        let pmIcon = UIImageView()
        pmIcon.translatesAutoresizingMaskIntoConstraints = false
        pmIcon.image = component.props.paymentMethodIcon
        pmIconView.paymentMethodIcon = pmIcon
        pmIconView.addSubview(pmIconView.paymentMethodIcon!)
        PXLayout.matchWidth(ofView: pmIconView.paymentMethodIcon!, toView: pmIconView.paymentMethodIconBackground).isActive = true
        PXLayout.matchHeight(ofView: pmIconView.paymentMethodIcon!, toView: pmIconView.paymentMethodIconBackground).isActive = true
        PXLayout.centerVertically(view: pmIconView.paymentMethodIcon!, into: pmIconView.paymentMethodIconBackground).isActive = true
        PXLayout.centerHorizontally(view: pmIconView.paymentMethodIcon!, to: pmIconView.paymentMethodIconBackground).isActive = true

        return pmIconView
    }
}

class PXPaymentMethodIconView: PXBodyView {
    var paymentMethodIcon: UIImageView?
    var paymentMethodIconBackground: UIImageView?
}
