//
//  PXPaymentMethodComponentRenderer.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 24/11/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXPaymentMethodComponentRenderer: NSObject {
    //Image
    let IMAGE_WIDTH: CGFloat = 48.0
    let IMAGE_HEIGHT: CGFloat = 48.0

    //Action Button
    let BUTTON_HEIGHT: CGFloat = 34.0

    let TITLE_FONT_SIZE: CGFloat = PXLayout.M_FONT
    let SUBTITLE_FONT_SIZE: CGFloat = PXLayout.XS_FONT
    let DESCRIPTION_DETAIL_FONT_SIZE: CGFloat = PXLayout.XXS_FONT
    let DISCLAIMER_FONT_SIZE: CGFloat = PXLayout.XXXS_FONT

    func render(component: PXPaymentMethodComponent) -> PXPaymentMethodView {
        let pmBodyView = PXPaymentMethodView()
        pmBodyView.backgroundColor = component.props.backgroundColor
        pmBodyView.translatesAutoresizingMaskIntoConstraints = false
        let paymentMethodIcon = component.getPaymentMethodIconComponent()
        pmBodyView.paymentMethodIcon = paymentMethodIcon.render()
        pmBodyView.paymentMethodIcon!.layer.cornerRadius = IMAGE_WIDTH/2
        pmBodyView.addSubview(pmBodyView.paymentMethodIcon!)
        PXLayout.centerHorizontally(view: pmBodyView.paymentMethodIcon!).isActive = true
        PXLayout.setHeight(owner: pmBodyView.paymentMethodIcon!, height: IMAGE_HEIGHT).isActive = true
        PXLayout.setWidth(owner: pmBodyView.paymentMethodIcon!, width: IMAGE_WIDTH).isActive = true
        PXLayout.pinTop(view: pmBodyView.paymentMethodIcon!, withMargin: PXLayout.L_MARGIN).isActive = true

        // Title
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        pmBodyView.titleLabel = title
        pmBodyView.addSubview(title)
        title.attributedText = component.props.title
        title.font = Utils.getFont(size: TITLE_FONT_SIZE)
        title.textColor = component.props.boldLabelColor
        title.textAlignment = .center
        title.numberOfLines = 0
        pmBodyView.putOnBottomOfLastView(view: title, withMargin: PXLayout.S_MARGIN)?.isActive = true
        PXLayout.pinLeft(view: title, withMargin: PXLayout.S_MARGIN).isActive = true
        PXLayout.pinRight(view: title, withMargin: PXLayout.S_MARGIN).isActive = true

        if let detailText = component.props.subtitle {
            let detailLabel = UILabel()
            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            pmBodyView.addSubview(detailLabel)
            pmBodyView.subtitleLabel = detailLabel
            detailLabel.attributedText = detailText
            detailLabel.font = Utils.getFont(size: SUBTITLE_FONT_SIZE)
            detailLabel.textColor = component.props.lightLabelColor
            detailLabel.textAlignment = .center
            PXLayout.setHeight(owner: detailLabel, height: 18.0).isActive = true
            pmBodyView.putOnBottomOfLastView(view: detailLabel, withMargin: PXLayout.XXS_MARGIN)?.isActive = true
            PXLayout.pinLeft(view: detailLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinRight(view: detailLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
        }

        if let paymentMethodDescription = component.props.descriptionTitle {
            let descriptionLabel = UILabel()
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            pmBodyView.addSubview(descriptionLabel)
            pmBodyView.descriptionTitleLabel = descriptionLabel
            descriptionLabel.attributedText = paymentMethodDescription
            descriptionLabel.font = Utils.getFont(size: DESCRIPTION_DETAIL_FONT_SIZE)
            descriptionLabel.numberOfLines = 2
            descriptionLabel.textColor = component.props.lightLabelColor
            descriptionLabel.textAlignment = .center
            pmBodyView.putOnBottomOfLastView(view: descriptionLabel, withMargin: PXLayout.XS_MARGIN)?.isActive = true
            PXLayout.pinLeft(view: descriptionLabel, withMargin: PXLayout.XS_MARGIN).isActive = true
            PXLayout.pinRight(view: descriptionLabel, withMargin: PXLayout.XS_MARGIN).isActive = true
        }

        if let pmDetailText = component.props.descriptionDetail {
            let pmDetailLabel = UILabel()
            pmDetailLabel.translatesAutoresizingMaskIntoConstraints = false
            pmBodyView.descriptionDetailLabel = pmDetailLabel
            pmBodyView.addSubview(pmDetailLabel)
            pmDetailLabel.attributedText = pmDetailText
            pmDetailLabel.font = Utils.getFont(size: DESCRIPTION_DETAIL_FONT_SIZE)
            pmDetailLabel.textColor = component.props.lightLabelColor
            pmDetailLabel.textAlignment = .center
            pmBodyView.putOnBottomOfLastView(view: pmDetailLabel, withMargin: PXLayout.XXS_MARGIN)?.isActive = true
            PXLayout.pinLeft(view: pmDetailLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinRight(view: pmDetailLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
        }

        if let disclaimer = component.props.disclaimer {
            let disclaimerLabel = UILabel()
            disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
            pmBodyView.disclaimerLabel = disclaimerLabel
            pmBodyView.addSubview(disclaimerLabel)
            disclaimerLabel.attributedText = disclaimer
            disclaimerLabel.numberOfLines = 2
            disclaimerLabel.font = Utils.getFont(size: DISCLAIMER_FONT_SIZE)
            disclaimerLabel.textColor = component.props.lightLabelColor
            disclaimerLabel.textAlignment = .center
            pmBodyView.putOnBottomOfLastView(view: disclaimerLabel, withMargin: PXLayout.M_MARGIN)?.isActive = true
            PXLayout.pinLeft(view: disclaimerLabel, withMargin: PXLayout.XS_MARGIN).isActive = true
            PXLayout.pinRight(view: disclaimerLabel, withMargin: PXLayout.XS_MARGIN).isActive = true
        }

        if let action = component.props.action {
            let actionButton = PXSecondaryButton()
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            actionButton.buttonTitle = action.label
            actionButton.add(for: .touchUpInside, action.action)
            pmBodyView.actionButton = actionButton
            pmBodyView.addSubview(actionButton)

            pmBodyView.putOnBottomOfLastView(view: actionButton, withMargin: PXLayout.S_MARGIN)?.isActive = true

            PXLayout.pinLeft(view: actionButton, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinRight(view: actionButton, withMargin: PXLayout.XXS_MARGIN).isActive = true
            //PXLayout.setHeight(owner: actionButton, height: BUTTON_HEIGHT).isActive = true
        }

        pmBodyView.pinLastSubviewToBottom(withMargin: PXLayout.L_MARGIN)?.isActive = true

        return pmBodyView
    }
}

// MARK: - OneTap
extension PXPaymentMethodComponentRenderer {

    func oneTapRender(component: PXPaymentMethodComponent) -> PXOneTapPaymentMethodView {
        let arrowImage: UIImage? = MercadoPago.getImage("oneTapArrow")
        var defaultHeight: CGFloat = 80
        let leftRightMargin = PXLayout.M_MARGIN
        let interMargin = PXLayout.S_MARGIN
        let pmView = PXOneTapPaymentMethodView()
        let cftColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 0.3) // Not in MLUI

        // PamentMethod Icon.
        let paymentMethodIcon = component.getPaymentMethodIconComponent()
        pmView.paymentMethodIcon = paymentMethodIcon.render()
        pmView.paymentMethodIcon?.layer.cornerRadius = IMAGE_WIDTH/2
        if let pmIcon = pmView.paymentMethodIcon {
            pmView.addSubview(pmIcon)
            PXLayout.pinLeft(view: pmIcon, withMargin: leftRightMargin).isActive = true
            PXLayout.setHeight(owner: pmIcon, height: IMAGE_HEIGHT).isActive = true
            PXLayout.setWidth(owner: pmIcon, width: IMAGE_WIDTH).isActive = true
            PXLayout.pinTop(view: pmIcon, to: pmView, withMargin: PXLayout.S_MARGIN).isActive = true
        }

        // PamentMethod Title.
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        pmView.paymentMethodTitle = title
        pmView.addSubview(title)
        title.attributedText = component.props.title
        title.font = Utils.getFont(size: PXLayout.XS_FONT)
        title.textColor = component.props.boldLabelColor
        title.textAlignment = .left
        title.numberOfLines = 1
        if let pmTitle = pmView.paymentMethodTitle, let pmIcon = pmView.paymentMethodIcon {
            PXLayout.put(view: pmTitle, rightOf: pmIcon, withMargin: interMargin).isActive = true
            PXLayout.pinRight(view: pmTitle, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.setHeight(owner: pmTitle, height: PXLayout.L_FONT).isActive = true
        }

        // PaymentMethod Subtitle.
        if let detailText = component.props.subtitle, let pmTitle = pmView.paymentMethodTitle, let pmIcon = pmView.paymentMethodIcon {
            let detailLabel = UILabel()
            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            pmView.addSubview(detailLabel)
            detailLabel.attributedText = detailText
            detailLabel.font = Utils.getFont(size: PXLayout.XXS_FONT)
            detailLabel.textColor = component.props.lightLabelColor
            detailLabel.textAlignment = .left
            PXLayout.setHeight(owner: detailLabel, height: PXLayout.M_FONT).isActive = true
            PXLayout.pinLeft(view: detailLabel, to: pmTitle).isActive = true
            PXLayout.pinTop(view: pmTitle, to: pmIcon, withMargin: PXLayout.XXXS_MARGIN).isActive = true
            PXLayout.pinBottom(view: detailLabel, to: pmIcon, withMargin: PXLayout.XXXS_MARGIN).isActive = true
            PXLayout.setWidth(owner: detailLabel, width: detailLabel.intrinsicContentSize.width).isActive = true
            pmView.paymentMethodSubtitle = detailLabel
        } else {
            if let pmTitle = pmView.paymentMethodTitle {
                PXLayout.centerVertically(view: pmTitle, to: pmView).isActive = true
            }
        }

        // Arrow image.
        if let pmIcon = pmView.paymentMethodIcon {
            let arrowImageView = UIImageView(image: arrowImage)
            arrowImageView.contentMode = .scaleAspectFit
            pmView.addSubview(arrowImageView)
            PXLayout.setHeight(owner: arrowImageView, height: PXLayout.XS_MARGIN).isActive = true
            PXLayout.setWidth(owner: arrowImageView, width: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.centerVertically(view: arrowImageView, to: pmIcon).isActive = true
            PXLayout.pinRight(view: arrowImageView, withMargin: PXLayout.S_MARGIN).isActive = true
        }

        // No interest label.
        if let noInterestAttr = component.props.descriptionTitle, let subtitleLabel = pmView.paymentMethodSubtitle {
            let noInterestLabel = UILabel()
            noInterestLabel.translatesAutoresizingMaskIntoConstraints = false
            pmView.addSubview(noInterestLabel)
            noInterestLabel.attributedText = noInterestAttr
            noInterestLabel.font = Utils.getFont(size: PXLayout.XXS_FONT)
            noInterestLabel.textColor = ThemeManager.shared.noTaxAndDiscountLabelTintColor()
            noInterestLabel.textAlignment = .left
            PXLayout.setHeight(owner: noInterestLabel, height: PXLayout.M_FONT).isActive = true
            PXLayout.centerVertically(view: noInterestLabel, to: subtitleLabel).isActive = true
            PXLayout.put(view: noInterestLabel, rightOf: subtitleLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true

            // CFT label.
            if let cftAttr = component.props.descriptionDetail {
                let cftLabel = UILabel()
                cftLabel.translatesAutoresizingMaskIntoConstraints = false
                pmView.addSubview(cftLabel)
                cftLabel.attributedText = cftAttr
                cftLabel.font = Utils.getFont(size: PXLayout.M_FONT)
                cftLabel.textColor = cftColor
                cftLabel.textAlignment = .left
                PXLayout.setHeight(owner: cftLabel, height: PXLayout.M_FONT).isActive = true
                PXLayout.pinLeft(view: cftLabel, to: subtitleLabel, withMargin: 0).isActive = true
                PXLayout.pinBottom(view: cftLabel, to: pmView, withMargin: PXLayout.S_MARGIN).isActive = true
                defaultHeight += PXLayout.M_MARGIN
            }
        }

        // Bordered line color.
        pmView.layer.borderWidth = 1
        pmView.layer.borderColor = ThemeManager.shared.lightTintColor().cgColor
        pmView.layer.cornerRadius = 4
        pmView.backgroundColor = component.props.backgroundColor
        pmView.translatesAutoresizingMaskIntoConstraints = false

        PXLayout.setHeight(owner: pmView, height: defaultHeight).isActive = true
        return pmView
    }
}

class PXOneTapPaymentMethodView: PXBodyView {
    var paymentMethodIcon: UIView?
    var paymentMethodTitle: UILabel?
    var paymentMethodSubtitle: UILabel?
    var installmentsIcon: UIView?
    var paymentMethodDescription: UILabel?
    var paymentMethodDetail: UILabel?
    var disclaimerLabel: UILabel?
    var actionButton: PXSecondaryButton?
}

class PXPaymentMethodView: PXBodyView {
    var paymentMethodIcon: UIView?
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var descriptionTitleLabel: UILabel?
    var descriptionDetailLabel: UILabel?
    var disclaimerLabel: UILabel?
    var actionButton: PXSecondaryButton?
}
