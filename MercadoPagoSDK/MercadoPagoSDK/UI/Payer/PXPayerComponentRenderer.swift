//
//  PXPayerComponentRenderer.swift
//  MercadoPagoSDK
//
//  Created by Marcelo José on 14/10/2018.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXPayerComponentRenderer: NSObject {

    //Action Button
    let BUTTON_HEIGHT: CGFloat = 34.0

    let LABEL_SIZE: CGFloat = PXLayout.M_FONT

    func render(component: PXPayerComponent) -> PXPayerView {
        let payerView = PXPayerView()
        payerView.backgroundColor = component.props.backgroundColor
        payerView.translatesAutoresizingMaskIntoConstraints = false

        // Identification
        let identification = UILabel()
        identification.translatesAutoresizingMaskIntoConstraints = false
        payerView.identificationLabel = identification
        payerView.addSubview(identification)
        identification.font = Utils.getFont(size: LABEL_SIZE)
        identification.attributedText = component.props.identityfication
        identification.textColor = component.props.labelColor
        identification.textAlignment = .center
        identification.numberOfLines = 0
        payerView.putOnBottomOfLastView(view: identification, withMargin: PXLayout.S_MARGIN)?.isActive = true
        PXLayout.pinLeft(view: identification, withMargin: PXLayout.S_MARGIN).isActive = true
        PXLayout.pinRight(view: identification, withMargin: PXLayout.S_MARGIN).isActive = true

        // Full Name
        let fullName = UILabel()
        fullName.translatesAutoresizingMaskIntoConstraints = false
        payerView.fullNameLabel = fullName
        payerView.addSubview(fullName)
        fullName.font = Utils.getFont(size: LABEL_SIZE)
        fullName.attributedText = component.props.fulltName
        fullName.textColor = component.props.labelColor
        fullName.textAlignment = .center
        fullName.numberOfLines = 0
        payerView.putOnBottomOfLastView(view: fullName, withMargin: PXLayout.S_MARGIN)?.isActive = true
        PXLayout.pinLeft(view: fullName, withMargin: PXLayout.S_MARGIN).isActive = true
        PXLayout.pinRight(view: fullName, withMargin: PXLayout.S_MARGIN).isActive = true

        // Action
        let actionButton = PXSecondaryButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.buttonTitle = component.props.action.label
        actionButton.add(for: .touchUpInside, component.props.action.action)
        payerView.actionButton = actionButton
        payerView.addSubview(actionButton)
        payerView.putOnBottomOfLastView(view: actionButton, withMargin: PXLayout.S_MARGIN)?.isActive = true
        PXLayout.pinLeft(view: actionButton, withMargin: PXLayout.XXS_MARGIN).isActive = true
        PXLayout.pinRight(view: actionButton, withMargin: PXLayout.XXS_MARGIN).isActive = true
       
        PXLayout.setHeight(owner: payerView, height: 150).isActive = true

        return payerView
    }
}
