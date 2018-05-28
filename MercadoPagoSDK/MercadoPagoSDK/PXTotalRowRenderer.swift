//
//  PXTotalRowRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 23/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

class PXTotalRowRenderer {

    var component: PXTotalRowComponent?

    func render(_ totalRowComponent: PXTotalRowComponent) -> UIView {
        component = totalRowComponent
        let ROW_HEIGHT: CGFloat = 67
        let PRIMARY_VALUE_HEIGHT: CGFloat = 19
        let SECONDARY_HEIGHT: CGFloat = 14

        let totalRowView = PXTotalRowView()
        totalRowView.translatesAutoresizingMaskIntoConstraints = false
        totalRowView.backgroundColor = .white
        totalRowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        totalRowView.layer.shadowColor = UIColor.black.cgColor
        totalRowView.layer.shadowRadius = 4
        totalRowView.layer.shadowOpacity = 0.25

        if totalRowComponent.props.showChevron {
            let chevronImageView = UIImageView()
            chevronImageView.translatesAutoresizingMaskIntoConstraints = false
            chevronImageView.backgroundColor = .red
            totalRowView.chevron = chevronImageView
            totalRowView.addSubview(chevronImageView)
            PXLayout.setWidth(owner: chevronImageView, width: 12).isActive = true
            PXLayout.setHeight(owner: chevronImageView, height: 12).isActive = true
            PXLayout.centerVertically(view: chevronImageView).isActive = true
            PXLayout.pinRight(view: chevronImageView, withMargin: PXLayout.S_MARGIN).isActive = true
        }

        if let title = totalRowComponent.props.title {
            let titleLabel = buildLabelWith(title)
            titleLabel.numberOfLines = 2
            totalRowView.titleLabel = titleLabel
            totalRowView.addSubview(titleLabel)
            PXLayout.pinLeft(view: titleLabel, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.setHeight(owner: titleLabel, height: SECONDARY_HEIGHT).isActive = true
        }

        if let disclaimer = totalRowComponent.props.disclaimer {
            let disclaimerLabel = buildLabelWith(disclaimer)
            disclaimerLabel.numberOfLines = 1
            totalRowView.disclaimerLabel = disclaimerLabel
            totalRowView.addSubview(disclaimerLabel)
            PXLayout.pinLeft(view: disclaimerLabel, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.setHeight(owner: disclaimerLabel, height: SECONDARY_HEIGHT).isActive = true
        }

        if let mainValue = totalRowComponent.props.mainValue {
            let mainValueLabel = buildLabelWith(mainValue)
            mainValueLabel.numberOfLines = 1
            totalRowView.mainValueLabel = mainValueLabel
            totalRowView.addSubview(mainValueLabel)
            if let chevron = totalRowView.chevron {
                PXLayout.pinRight(view: mainValueLabel, to: chevron, withMargin: PXLayout.S_MARGIN).isActive = true
            } else {
                PXLayout.pinRight(view: mainValueLabel, withMargin: PXLayout.S_MARGIN).isActive = true
            }
            PXLayout.setHeight(owner: mainValueLabel, height: PRIMARY_VALUE_HEIGHT).isActive = true
        }

        if let secondaryValue = totalRowComponent.props.secondaryValue {
            let secondaryValueLabel = buildLabelWith(secondaryValue)
            secondaryValueLabel.numberOfLines = 1
            totalRowView.secondaryValueLabel = secondaryValueLabel
            totalRowView.addSubview(secondaryValueLabel)
            if let chevron = totalRowView.chevron {
                PXLayout.pinRight(view: secondaryValueLabel, to: chevron, withMargin: PXLayout.S_MARGIN).isActive = true
            } else {
                PXLayout.pinRight(view: secondaryValueLabel, withMargin: PXLayout.S_MARGIN).isActive = true
            }
            PXLayout.setHeight(owner: secondaryValueLabel, height: SECONDARY_HEIGHT).isActive = true
        }

        PXLayout.setHeight(owner: totalRowView, height: ROW_HEIGHT).isActive = true
        layoutComponentsOf(totalRowView)

        return totalRowView
    }

    func layoutComponentsOf(_ view: PXTotalRowView) {

        if let title = view.titleLabel, let disclaimer = view.disclaimerLabel {
            PXLayout.pinTop(view: title, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.put(view: disclaimer, onBottomOf: title, withMargin: PXLayout.XXXS_MARGIN).isActive = true
            PXLayout.pinBottom(view: disclaimer, withMargin: PXLayout.S_MARGIN).isActive = true
        } else if let title = view.titleLabel, view.disclaimerLabel == nil {
            PXLayout.centerVertically(view: title).isActive = true
        } else if let disclaimer = view.disclaimerLabel, view.titleLabel == nil {
            PXLayout.centerVertically(view: disclaimer).isActive = true
        }

        if let mainValue = view.mainValueLabel, let secondaryValue = view.secondaryValueLabel {
            PXLayout.pinTop(view: secondaryValue, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.put(view: mainValue, onBottomOf: secondaryValue, withMargin: PXLayout.XXXS_MARGIN).isActive = true
            PXLayout.pinBottom(view: mainValue, withMargin: PXLayout.S_MARGIN).isActive = true
        } else if let mainValue = view.mainValueLabel, view.secondaryValueLabel == nil {
            PXLayout.centerVertically(view: mainValue).isActive = true
        } else if let secondaryValue = view.secondaryValueLabel, view.mainValueLabel == nil {
            PXLayout.centerVertically(view: secondaryValue).isActive = true
        }
    }

    func buildLabelWith(_ text: NSAttributedString) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = text
        return label
    }

}

class PXTotalRowView: PXComponentView {
    public var titleLabel: UILabel?
    public var disclaimerLabel: UILabel?
    public var mainValueLabel: UILabel?
    public var secondaryValueLabel: UILabel?
    public var chevron: UIImageView?
}
