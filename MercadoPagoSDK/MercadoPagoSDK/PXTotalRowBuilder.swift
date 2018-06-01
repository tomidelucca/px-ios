//
//  PXTotalRowBuilder.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 31/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXTotalRowBuilder: PXTotalRowComponent {

    init(amountHelper: PXAmountHelper, shouldShowChevron: Bool = false) {
        let currency = MercadoPagoContext.getCurrency()
        var title: NSAttributedString?
        var disclaimer: NSAttributedString?
        var mainValue: NSAttributedString?
        var secondaryValue: NSAttributedString?

        //////////////// TITLE ////////////////
            //TODO: Add translations
        if MercadoPagoCheckoutViewModel.flowPreference.isDiscountEnable() {
            let addNewDiscountAttributes = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XXS_FONT), NSAttributedStringKey.foregroundColor: UIColor.UIColorFromRGB(0x3483fa)]
            let activeDiscountAttributes = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XXS_FONT), NSAttributedStringKey.foregroundColor: UIColor.UIColorFromRGB(0x39b54a)]

            if let discount = amountHelper.discount {
                if discount.amountOff > 0.0 {
                    let string = NSMutableAttributedString(string: "- $ ", attributes: activeDiscountAttributes)
                    string.append(NSAttributedString(string: String(describing: discount.amountOff), attributes: activeDiscountAttributes))
                    string.append(NSAttributedString(string: " OFF", attributes: activeDiscountAttributes))
                    title = string
                } else if discount.percentOff > 0.0 {
                    let string = NSMutableAttributedString(string: "", attributes: activeDiscountAttributes)
                    string.append(NSAttributedString(string: String(describing: discount.percentOff), attributes: activeDiscountAttributes))
                    string.append(NSAttributedString(string: "% OFF", attributes: activeDiscountAttributes))
                    title = string
                }
            } else {
                let defaultTitleString = "Ingresá tu cupón de descuento"
                let defaultTitleAttributedString = NSAttributedString(string: defaultTitleString, attributes: addNewDiscountAttributes)
                title = defaultTitleAttributedString
            }
        } else {
            let defaultTitleString = "Total a pagar"
            let defaultAttributes = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XXS_FONT), NSAttributedStringKey.foregroundColor: UIColor.UIColorFromRGB(0x666666)]
            let defaultTitleAttributedString = NSAttributedString(string: defaultTitleString, attributes: defaultAttributes)
            title = defaultTitleAttributedString
        }

        //////////////// DISCLAIMER ////////////////
        if amountHelper.maxCouponAmount != nil {
            let attributes = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XXS_FONT), NSAttributedStringKey.foregroundColor: UIColor.UIColorFromRGB(0x999999)]
            let string = NSAttributedString(string: "con tope de descuento", attributes: attributes)
            disclaimer = string
        }

        //////////////// MAIN VALUE ////////////////
        let amountFontSize: CGFloat = PXLayout.L_FONT
        //TODO: amount con centavos
        let string = Utils.getAttributedAmount(amountHelper.amountToPay, currency: currency, color: UIColor.UIColorFromRGB(0x333333), fontSize: amountFontSize, centsFontSize: amountFontSize, baselineOffset: 0, negativeAmount: false)

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        string.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: string.length))

        mainValue = string

        //////////////// SECONDARY VALUE ////////////////
        if amountHelper.discount != nil {
            let oldAmount = Utils.getAttributedAmount(amountHelper.amountWithoutDiscount, currency: currency, color: UIColor.UIColorFromRGB(0xa3a3a3), fontSize: PXLayout.XXS_FONT, baselineOffset: 0)

            oldAmount.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: oldAmount.length))

            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .right
            oldAmount.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: oldAmount.length))

            secondaryValue = oldAmount
        }

        //////////////// PROPS INIT ////////////////
        let props = PXTotalRowProps(title: title, disclaimer: disclaimer, mainValue: mainValue, secondaryValue: secondaryValue, showChevron: shouldShowChevron)

        super.init(props: props)
    }

    static func shouldAddActionToRow() -> Bool {
        if MercadoPagoCheckoutViewModel.flowPreference.isDiscountEnable() {
            return true
        }
        return false
    }

    static func handleTap(amountHelper: PXAmountHelper) {
        if amountHelper.discount != nil {
            PXComponentFactory.Modal.show(viewController: PXDiscountDetailViewController(amountHelper: amountHelper), title: "discount_detail_modal_title".localized_beta)
        }
    }
}
