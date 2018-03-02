//
//  PXItemRenderer.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 3/1/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

struct PXItemRenderer {
    let CONTENT_WIDTH_PERCENT: CGFloat = 86.0

    // Font sizes
    static let TITLE_FONT_SIZE: CGFloat = PXLayout.M_FONT
    static let DESCRIPTION_FONT_SIZE = PXLayout.XXS_FONT
    static let QUANTITY_FONT_SIZE = PXLayout.XS_FONT
    static let AMOUNT_FONT_SIZE = PXLayout.XS_FONT

    func render(_ itemComponent: PXItemComponent) -> UIView {
        let itemView = PXItemContainerView()

        itemView.itemImage = buildItemImage(imageURL: itemComponent.props.imageURL)

        if let itemImage = itemView.itemImage {
            itemView.addSubview(itemImage)
            PXLayout.centerHorizontally(view: itemImage).isActive = true
            PXLayout.pinTop(view: itemImage, withMargin: PXLayout.L_MARGIN).isActive = true
        }

        itemView.itemTitle = buildTitle(with: itemComponent.getTitle())

        if let itemTitle = itemView.itemTitle {
            itemView.addSubviewToButtom(itemTitle, withMargin: PXLayout.S_MARGIN)
            PXLayout.centerHorizontally(view: itemTitle).isActive = true
            PXLayout.matchWidth(ofView: itemTitle, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        itemView.itemDescription = buildDescription(with: itemComponent.getDescription())

        if let itemDescription = itemView.itemDescription {
            itemView.addSubviewToButtom(itemDescription, withMargin: PXLayout.XS_MARGIN)
            PXLayout.centerHorizontally(view: itemDescription).isActive = true
            PXLayout.matchWidth(ofView: itemDescription, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        itemView.itemQuantity = buildQuantity(with: itemComponent.getQuantity())

        if let itemQuantity = itemView.itemQuantity {
            itemView.addSubviewToButtom(itemQuantity, withMargin: PXLayout.XS_MARGIN)
            PXLayout.centerHorizontally(view: itemQuantity).isActive = true
            PXLayout.matchWidth(ofView: itemQuantity, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        itemView.itemAmount = buildItemAmount(with: itemComponent.getUnitAmount())
        if let itemAmount = itemView.itemAmount {
            itemView.addSubviewToButtom(itemAmount, withMargin: PXLayout.XXXS_MARGIN)
            PXLayout.centerHorizontally(view: itemAmount).isActive = true
            PXLayout.matchWidth(ofView: itemAmount, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        PXLayout.pinLastSubviewToBottom(view: itemView)?.isActive = true
        return itemView
    }

    fileprivate func buildItemImage(imageURL: String?) -> UIImageView {
        let imageView = UIImageView()

        if let image =  ViewUtils.loadImageFromUrl(imageURL) {
            imageView.image = image
        } else {
            imageView.image = MercadoPago.getImage("MPSDK_review_iconoCarrito")
        }
        return imageView
    }

    fileprivate func buildTitle(with text: String?) -> UILabel? {
        guard let text = text else {
            return nil
        }
        let font = Utils.getFont(size: PXItemRenderer.TITLE_FONT_SIZE)
        let color = UIColor.px_grayBaseText()
        return buildLabel(text: text, color: color, font: font)
    }

    fileprivate func buildDescription(with text: String?) -> UILabel? {
        guard let text = text else {
            return nil
        }

        let font = Utils.getFont(size: PXItemRenderer.DESCRIPTION_FONT_SIZE)
        let color = UIColor.px_grayDark()
        return buildLabel(text: text, color: color, font: font)
    }

    func buildQuantity(with text: String?) -> UILabel? {
        guard let text = text else {
            return nil
        }

        let font = Utils.getFont(size: PXItemRenderer.QUANTITY_FONT_SIZE)
        let color = UIColor.px_grayDark()
        return buildLabel(text: text, color: color, font: font)
    }

    fileprivate func buildItemAmount(with text: String?) -> UILabel? {
        guard let text = text else {
            return nil
        }

        let font = Utils.getFont(size: PXItemRenderer.AMOUNT_FONT_SIZE)
        let color = UIColor.px_grayDark()
        return buildLabel(text: text, color: color, font: font)
    }

    fileprivate func buildLabel(text: String, color: UIColor, font: UIFont) -> UILabel {
        let itemDescription = UILabel()
        itemDescription.textAlignment = .center
        itemDescription.text = text
        itemDescription.textColor = color
        itemDescription.lineBreakMode = .byWordWrapping
        itemDescription.numberOfLines = 0
        itemDescription.font = font
        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)
        let height = UILabel.requiredHeight(forText: text, withFont: font, inWidth: screenWidth)
        PXLayout.setHeight(owner: itemDescription, height: height).isActive = true
        return itemDescription
    }
}

class PXItemContainerView: PXComponentView {
    var itemImage: UIImageView?
    var itemTitle: UILabel?
    var itemDescription: UILabel?
    var itemQuantity: UILabel?
    var itemAmount: UILabel?
}
