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
    //Image
    static let IMAGE_WIDTH: CGFloat = 48.0
    static let IMAGE_HEIGHT: CGFloat = 48.0

    // Font sizes
    static let TITLE_FONT_SIZE = PXLayout.M_FONT
    static let DESCRIPTION_FONT_SIZE = PXLayout.XXS_FONT
    static let QUANTITY_FONT_SIZE = PXLayout.XS_FONT
    static let AMOUNT_FONT_SIZE = PXLayout.XS_FONT

    func render(_ itemComponent: PXItemComponent) -> PXItemContainerView {
        let itemView = PXItemContainerView()
        itemView.backgroundColor = itemComponent.props.backgroundColor
        itemView.translatesAutoresizingMaskIntoConstraints = false

        itemView.itemImage = buildItemImage(imageURL: itemComponent.props.imageURL, collectorImage: itemComponent.props.reviewScreenPreference.getCollectorIcon())

        // Item icon
        if let itemImage = itemView.itemImage {
            itemView.addSubview(itemImage)
            PXLayout.centerHorizontally(view: itemImage).isActive = true
            PXLayout.setHeight(owner: itemImage, height: PXItemRenderer.IMAGE_HEIGHT).isActive = true
            PXLayout.setWidth(owner: itemImage, width: PXItemRenderer.IMAGE_WIDTH).isActive = true
            PXLayout.pinTop(view: itemImage, withMargin: PXLayout.L_MARGIN).isActive = true
        }

        // Item Title
        if itemComponent.shouldShowTitle() {
            itemView.itemTitle = buildTitle(with: itemComponent.getTitle(), labelColor: itemComponent.props.boldLabelColor)
        }
        if let itemTitle = itemView.itemTitle {
            itemView.addSubviewToButtom(itemTitle, withMargin: PXLayout.S_MARGIN)
            PXLayout.centerHorizontally(view: itemTitle).isActive = true
            PXLayout.matchWidth(ofView: itemTitle, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        // Item description
        if itemComponent.shouldShowDescription() {
            itemView.itemDescription = buildDescription(with: itemComponent.getDescription(), labelColor: itemComponent.props.lightLabelColor)
        }
        if let itemDescription = itemView.itemDescription {
            itemView.addSubviewToButtom(itemDescription, withMargin: PXLayout.XS_MARGIN)
            PXLayout.centerHorizontally(view: itemDescription).isActive = true
            PXLayout.matchWidth(ofView: itemDescription, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        // Item quantity
        if itemComponent.shouldShowQuantity() {
            itemView.itemQuantity = buildQuantity(with: itemComponent.getQuantity(), labelColor: itemComponent.props.lightLabelColor)
        }
        if let itemQuantity = itemView.itemQuantity {
            itemView.addSubviewToButtom(itemQuantity, withMargin: PXLayout.XS_MARGIN)
            PXLayout.centerHorizontally(view: itemQuantity).isActive = true
            PXLayout.matchWidth(ofView: itemQuantity, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        // Item amount
        if itemComponent.shouldShowUnitAmount() {
            itemView.itemAmount = buildItemAmount(with: itemComponent.getUnitAmountPrice(), title: itemComponent.getUnitAmountTitle(), labelColor: itemComponent.props.lightLabelColor)
        }
        if let itemAmount = itemView.itemAmount {
            let margin = itemView.itemQuantity == nil ? PXLayout.XS_MARGIN : PXLayout.XXXS_MARGIN
            itemView.addSubviewToButtom(itemAmount, withMargin: margin)
            PXLayout.centerHorizontally(view: itemAmount).isActive = true
            PXLayout.matchWidth(ofView: itemAmount, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        itemView.pinLastSubviewToBottom(withMargin: PXLayout.L_MARGIN)?.isActive = true
        return itemView
    }
}

extension PXItemRenderer {

    fileprivate func buildItemImage(imageURL: String?, collectorImage: UIImage? = nil) -> UIImageView {
        let imageView = UIImageView()
 
        if imageURL != nil {
            let circleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: PXItemRenderer.IMAGE_WIDTH, height: PXItemRenderer.IMAGE_HEIGHT))
            DispatchQueue.global(qos: .background).async {
                if let image =  ViewUtils.loadImageFromUrl(imageURL) {
                    DispatchQueue.main.async {
                        circleImage.image = image
                        circleImage.layer.masksToBounds = false
                        circleImage.layer.cornerRadius = circleImage.frame.height/2
                        circleImage.clipsToBounds = true
                        circleImage.translatesAutoresizingMaskIntoConstraints = false
                        circleImage.contentMode = .scaleAspectFill
                    }
                } else {
                   circleImage.image = MercadoPago.getImage("MPSDK_review_iconoCarrito")
                }
            }
            return circleImage
        } else if let image =  collectorImage {
            imageView.image = image
        } else {
            imageView.image = MercadoPago.getImage("MPSDK_review_iconoCarrito")
        }
        return imageView
    }

    fileprivate func buildTitle(with text: String?, labelColor: UIColor) -> UILabel? {
        guard let text = text else {
            return nil
        }

        let font = Utils.getFont(size: PXItemRenderer.TITLE_FONT_SIZE)
        return buildLabel(text: text, color: labelColor, font: font)
    }

    fileprivate func buildDescription(with text: String?, labelColor: UIColor) -> UILabel? {
        guard let text = text else {
            return nil
        }

        let font = Utils.getFont(size: PXItemRenderer.DESCRIPTION_FONT_SIZE)
        return buildLabel(text: text, color: labelColor, font: font)
    }

    func buildQuantity(with text: String?, labelColor: UIColor) -> UILabel? {
        guard let text = text else {
            return nil
        }

        let font = Utils.getFont(size: PXItemRenderer.QUANTITY_FONT_SIZE)
        return buildLabel(text: text, color: labelColor, font: font)
    }

    fileprivate func buildItemAmount(with amount: Double?, title: String?, labelColor: UIColor) -> UILabel? {
        guard let title = title, let amount = amount else {
            return nil
        }

        let font = Utils.getFont(size: PXItemRenderer.AMOUNT_FONT_SIZE)

        let unitPrice = buildAttributedUnitAmount(amount: amount, color: labelColor, fontSize: font.pointSize)
        let unitPriceTitle = NSMutableAttributedString(string: title, attributes: [NSFontAttributeName: font])
        unitPriceTitle.append(unitPrice)

        return buildLabel(attributedText: unitPriceTitle, color: labelColor, font: font)
    }

    fileprivate func buildAttributedUnitAmount(amount: Double, color: UIColor, fontSize: CGFloat) -> NSAttributedString {
        let currency = MercadoPagoContext.getCurrency()
        return Utils.getAmountFormatted(amount: amount, thousandSeparator: currency.thousandsSeparator, decimalSeparator: currency.decimalSeparator, addingCurrencySymbol: currency.symbol).toAttributedString()
    }

    fileprivate func buildLabel(text: String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.textColor = color
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = font
        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)
        let height = UILabel.requiredHeight(forText: text, withFont: font, inWidth: screenWidth)
        PXLayout.setHeight(owner: label, height: height).isActive = true
        return label
    }

    fileprivate func buildLabel(attributedText: NSAttributedString, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = color
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = font
        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)
        let height = UILabel.requiredHeight(forAttributedText: attributedText, withFont: font, inWidth: screenWidth)
        PXLayout.setHeight(owner: label, height: height).isActive = true
        return label
    }
}

