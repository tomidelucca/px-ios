//
//  PXOneTapItemRenderer.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 16/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXOneTapItemRenderer {
    let CONTENT_WIDTH_PERCENT: CGFloat = 86.0

    // Image
    static let IMAGE_WIDTH: CGFloat = 64.0
    static let IMAGE_HEIGHT: CGFloat = 64.0

    // Fonts
    static let AMOUNT_FONT_SIZE: CGFloat = 44.0
    static let TITLE_FONT_SIZE = PXLayout.S_FONT
    static let AMOUNT_WITHOUT_DISCOUNT = PXLayout.XS_FONT

    let arrow: UIImage? = MercadoPago.getImage("oneTapArrow")

    func oneTapRender(_ itemComponent: PXOneTapItemComponent) -> PXOneTapItemContainerView {
        let itemView = PXOneTapItemContainerView()
        itemView.translatesAutoresizingMaskIntoConstraints = false

        let imageObj = buildItemImageUrl(collectorImage: itemComponent.props.collectorImage)

        itemView.itemImage = UIImageView()

        // Item icon
        if let itemImage = itemView.itemImage {
            itemImage.image = imageObj
            itemImage.layer.cornerRadius = PXOneTapItemRenderer.IMAGE_HEIGHT/2
            itemImage.layer.borderWidth = 3
            itemImage.layer.borderColor = ThemeManager.shared.iconBackgroundColor().cgColor
            itemView.addSubviewToBottom(itemImage)
            PXLayout.centerHorizontally(view: itemImage).isActive = true
            PXLayout.setHeight(owner: itemImage, height: PXOneTapItemRenderer.IMAGE_HEIGHT).isActive = true
            PXLayout.setWidth(owner: itemImage, width: PXOneTapItemRenderer.IMAGE_WIDTH).isActive = true
        }

        // Item Title
        itemView.itemTitle = buildTitle(with: itemComponent.props.title, labelColor: ThemeManager.shared.boldLabelTintColor())

        if let itemTitle = itemView.itemTitle {
            itemView.addSubviewToBottom(itemTitle, withMargin: PXLayout.S_MARGIN)
            PXLayout.centerHorizontally(view: itemTitle).isActive = true
            PXLayout.matchWidth(ofView: itemTitle, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        // Discount
        itemView.amountWithoutDiscount = buildAmountWithoutDiscount(with: itemComponent.props.amountWithoutDiscount, description: itemComponent.props.discountDescription, labelColor: ThemeManager.shared.greyColor())

        if let amountWithoutDiscount = itemView.amountWithoutDiscount {
            itemView.addSubviewToBottom(amountWithoutDiscount, withMargin: PXLayout.XXS_MARGIN)
            PXLayout.centerHorizontally(view: amountWithoutDiscount).isActive = true
            PXLayout.matchWidth(ofView: amountWithoutDiscount, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        }

        itemView.totalView = UIView(frame: .zero)

        // Item amount
        let totalAmount = buildItemAmount(with: itemComponent.props.totalAmount, labelColor: ThemeManager.shared.boldLabelTintColor())

        if let totalAmount = totalAmount {
            totalAmount.translatesAutoresizingMaskIntoConstraints = false
            itemView.totalView?.addSubview(totalAmount)
            itemView.totalView?.layoutIfNeeded()

            PXLayout.pinTop(view: totalAmount).isActive = true
            PXLayout.pinLeft(view: totalAmount).isActive = true

            // Arrow image.
            let arrow = UIImageView(image: self.arrow)

            let transformation = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi / 2))
            arrow.transform = transformation
            arrow.contentMode = .scaleAspectFit
            arrow.translatesAutoresizingMaskIntoConstraints = false
            itemView.totalView?.addSubview(arrow)
            PXLayout.setHeight(owner: arrow, height: PXLayout.XS_MARGIN).isActive = true
            PXLayout.setWidth(owner: arrow, width: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.centerVertically(view: arrow, to: totalAmount).isActive = true
            PXLayout.pinRight(view: arrow, to: totalAmount, withMargin: -PXLayout.S_MARGIN).isActive = true
        }

        if let totalView = itemView.totalView {
            let widthSubviews = totalView.subviews.reduce(0) {$0 + $1.frame.width}
            PXLayout.setWidth(owner: totalView, width: widthSubviews + PXLayout.S_MARGIN).isActive = true
            itemView.addSubviewToBottom(totalView, withMargin: PXLayout.XXS_MARGIN)
            PXLayout.centerHorizontally(view: totalView).isActive = true
            PXLayout.setHeight(owner: totalView, height: PXOneTapItemRenderer.AMOUNT_FONT_SIZE).isActive = true
        }

        itemView.pinLastSubviewToBottom(withMargin: PXLayout.ZERO_MARGIN)?.isActive = true
        return itemView
    }
}

extension PXOneTapItemRenderer {

    fileprivate func buildTitle(with text: String?, labelColor: UIColor) -> UILabel? {
        guard let text = text else {
            return nil
        }

        let font = Utils.getSemiBoldFont(size: PXOneTapItemRenderer.TITLE_FONT_SIZE)
        return buildLabel(text: text, color: labelColor, font: font)
    }

    fileprivate func buildItemAmount(with amount: Double?, labelColor: UIColor) -> UILabel? {
        guard let amount = amount else {
            return nil
        }

        let font = Utils.getLightFont(size: PXOneTapItemRenderer.AMOUNT_FONT_SIZE)
        let unitPrice = buildAttributedTotalAmount(amount: amount, color: labelColor, fontSize: font.pointSize)
        return buildLabel(attributedText: unitPrice, color: labelColor, font: font)
    }

    fileprivate func buildAmountWithoutDiscount(with amount: Double?, description: String?, labelColor: UIColor) -> UILabel? {
        guard let title = description, let amount = amount else {
            return nil
        }

        let font = Utils.getFont(size: PXOneTapItemRenderer.AMOUNT_WITHOUT_DISCOUNT)
        let totalWithoutDiscount = NSMutableAttributedString(attributedString: buildAttributedTotalAmountWithoutDiscount(amount: amount, color: labelColor, font: font))
        let discountDescription = NSMutableAttributedString(string: " - " + title, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: ThemeManager.shared.noTaxAndDiscountLabelTintColor()])
        totalWithoutDiscount.append(discountDescription)
        return buildLabel(attributedText: totalWithoutDiscount, color: labelColor, font: font)
    }

    fileprivate func buildAttributedTotalAmount(amount: Double, color: UIColor, fontSize: CGFloat) -> NSAttributedString {
        let currency = MercadoPagoContext.getCurrency()
        return Utils.getAttributedAmount(amount, currency: currency, color: color, fontSize: fontSize, centsFontSize: 20, baselineOffset: 16, lightFont: true)
    }

    fileprivate func buildAttributedTotalAmountWithoutDiscount(amount: Double, color: UIColor, font: UIFont) -> NSAttributedString {
        let currency = MercadoPagoContext.getCurrency()
        let amount = Utils.getAmountFormatted(amount: amount, thousandSeparator: currency.thousandsSeparator, decimalSeparator: currency.decimalSeparator, addingCurrencySymbol: currency.symbol).toAttributedString()
        let amountString = NSMutableAttributedString(attributedString: amount)
        amountString.addAttributes([NSAttributedStringKey.font: font], range: NSRange(location: 0, length: amount.length))
        amountString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: amount.length))
        return amountString
    }

    fileprivate func buildLabel(text: String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.textColor = color
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = font
        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)
        let height = UILabel.requiredHeight(forText: text, withFont: font, inNumberOfLines: 1, inWidth: screenWidth)
        PXLayout.setHeight(owner: label, height: height).isActive = true
        return label
    }

    fileprivate func buildLabel(attributedText: NSAttributedString, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = color
        label.attributedText = attributedText
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1

        PXLayout.setHeight(owner: label, height: font.pointSize).isActive = true
        return label
    }

    fileprivate func buildItemImageUrl(collectorImage: UIImage? = nil) -> UIImage? {
        if let image = collectorImage {
            return image
        } else {
            return MercadoPago.getImage("MPSDK_review_iconoCarrito")
        }
    }
}
