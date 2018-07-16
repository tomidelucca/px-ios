//
//  PXTotalRowBuilder.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 31/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServicesV4

final class PXTotalRowBuilder: PXTotalRowComponent {

    init(amountHelper: PXAmountHelper, shouldShowChevron: Bool = false) {
        let currency = MercadoPagoContext.getCurrency()
        var title: NSAttributedString?
        var disclaimer: NSAttributedString?
        var mainValue: NSAttributedString?
        var secondaryValue: NSAttributedString?

        //////////////// TITLE ////////////////
        if let discount = amountHelper.discount {

            let activeDiscountAttributes = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XXS_FONT),
                                            NSAttributedStringKey.foregroundColor: ThemeManager.shared.noTaxAndDiscountLabelTintColor()]

            let string = discount.getDiscountDescription()
            let attributedString = NSMutableAttributedString(string: string, attributes: activeDiscountAttributes)
            title = attributedString
        } else if let currentCheckout = MercadoPagoCheckout.currentCheckout, currentCheckout.viewModel.shouldShowDiscountInput() {
            let addNewDiscountAttributes = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XXS_FONT),
                                            NSAttributedStringKey.foregroundColor: ThemeManager.shared.secondaryColor()]

            let string = "total_row_title_add_coupon".localized_beta
            let attributedString = NSAttributedString(string: string, attributes: addNewDiscountAttributes)
            title = attributedString
        } else {
            let defaultTitleString = "total_row_title_default".localized_beta
            let defaultAttributes = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XXS_FONT),
                                     NSAttributedStringKey.foregroundColor: ThemeManager.shared.labelTintColor()]

            let defaultTitleAttributedString = NSAttributedString(string: defaultTitleString, attributes: defaultAttributes)
            title = defaultTitleAttributedString
        }

        //////////////// DISCLAIMER ////////////////
        if amountHelper.maxCouponAmount != nil {
            let attributes = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XXS_FONT),
                              NSAttributedStringKey.foregroundColor: ThemeManager.shared.greyColor()]

            let string = NSAttributedString(string: "total_row_disclaimer".localized_beta, attributes: attributes)
            disclaimer = string
        }

        //////////////// MAIN VALUE ////////////////
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        let attributes = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.L_FONT),
                          NSAttributedStringKey.foregroundColor: ThemeManager.shared.boldLabelTintColor(),
                          NSAttributedStringKey.paragraphStyle: paragraph]

        let string = Utils.getAttributedAmount(withAttributes: attributes, amount: amountHelper.amountToPay, currency: currency, negativeAmount: false)

        mainValue = string

        //////////////// SECONDARY VALUE ////////////////
        if amountHelper.discount != nil {

            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .right
            let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XXS_FONT),
                              NSAttributedStringKey.foregroundColor: ThemeManager.shared.greyColor(),
                              NSAttributedStringKey.paragraphStyle: paragraph,
                              NSAttributedStringKey.strikethroughStyle: 1]

            let string = Utils.getAttributedAmount(withAttributes: attributes, amount: amountHelper.preferenceAmountWithCharges, currency: currency, negativeAmount: false)

            secondaryValue = string
        }

        //////////////// PROPS INIT ////////////////
        let props = PXTotalRowProps(title: title, disclaimer: disclaimer, mainValue: mainValue, secondaryValue: secondaryValue, showChevron: shouldShowChevron)

        super.init(props: props)
    }

    static func shouldAddActionToRow(amountHelper: PXAmountHelper) -> Bool {
        if amountHelper.discount != nil {
            return true
        }
        return false
    }

    static func handleTap(amountHelper: PXAmountHelper, discountValidationCallback: @escaping (PXDiscount, PXCampaign, @escaping ()->Void, @escaping ()->Void) -> Void) {
        if amountHelper.discount != nil {
            PXComponentFactory.Modal.show(viewController: PXDiscountDetailViewController(amountHelper: amountHelper), title: "discount_detail_modal_title".localized_beta)
        } else if let currentCheckout = MercadoPagoCheckout.currentCheckout, currentCheckout.viewModel.shouldShowDiscountInput() {
            let inputVC = PXDiscountCodeInputViewController(discountValidationCallback: discountValidationCallback) {
                print("hola hola")
            }
            PXComponentFactory.Modal.show(viewController: inputVC, title: nil)
        }
    }
}
