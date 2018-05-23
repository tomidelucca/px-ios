//
//  PXTotalRowRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 23/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

struct PXTotalRowRenderer {

    func render(_ totalRowComponent: PXTotalRowComponent) -> UIView {
        let totalRowView = PXTotalRowView()
        totalRowView.translatesAutoresizingMaskIntoConstraints = false
        totalRowView.backgroundColor = .white
        totalRowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        totalRowView.layer.shadowColor = UIColor.black.cgColor
        totalRowView.layer.shadowRadius = 4
        totalRowView.layer.shadowOpacity = 0.25

        if let action = totalRowComponent.props.action {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(action.label, for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.add(for: .touchUpInside, action.action)
            button.layer.borderWidth = 1
            totalRowView.discountAction = button
            totalRowView.addSubviewToBottom(button, withMargin: PXLayout.XS_MARGIN)
            PXLayout.pinTop(view: button, withMargin: PXLayout.XS_MARGIN).isActive = true
            PXLayout.pinLeft(view: button, withMargin: PXLayout.S_MARGIN).isActive = true

            if let actionValue = totalRowComponent.props.actionValue {
                let actionValueLabel = UILabel()
                actionValueLabel.translatesAutoresizingMaskIntoConstraints = false
                actionValueLabel.attributedText = actionValue
                totalRowView.discountValueLabel = actionValueLabel
                totalRowView.addSubview(actionValueLabel)
                PXLayout.centerVertically(view: actionValueLabel, to: button).isActive = true
                PXLayout.pinRight(view: actionValueLabel, withMargin: PXLayout.S_MARGIN).isActive = true
            }
        }


        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.attributedText = totalRowComponent.props.title
        totalRowView.titleLabel = titleLabel
        totalRowView.addSubviewToBottom(titleLabel, withMargin: PXLayout.XS_MARGIN)
        titleLabel.layer.borderWidth = 1
        PXLayout.pinBottom(view: titleLabel, withMargin: PXLayout.XS_MARGIN).isActive = true
        PXLayout.pinLeft(view: titleLabel, withMargin: PXLayout.S_MARGIN).isActive = true

        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.attributedText = totalRowComponent.props.value
        totalRowView.valueLabel = valueLabel
        totalRowView.addSubview(valueLabel)
        PXLayout.centerVertically(view: valueLabel, to: titleLabel).isActive = true
        PXLayout.pinRight(view: valueLabel, withMargin: PXLayout.S_MARGIN).isActive = true

        return totalRowView
    }
}

class PXTotalRowView: PXComponentView {
    public var discountAction: UIButton?
    public var discountValueLabel: UILabel?
    public var discountDetailLabel: UILabel?
    public var titleLabel: UILabel?
    public var valueLabel: UILabel?
}
