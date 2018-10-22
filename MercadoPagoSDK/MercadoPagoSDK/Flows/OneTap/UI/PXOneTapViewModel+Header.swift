//
//  PXOneTapViewModel+Header.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 18/10/18.
//

import Foundation

extension PXOneTapViewModel {

    func getHeaderViewModel() -> PXOneTapHeaderViewModel {

        var data: [OneTapHeaderSummaryData] = []

        let currency: PXCurrency = SiteManager.shared.getCurrency()

        // Add items row data
        let itemsAmountString = Utils.getAmountFormatted(amount: self.amountHelper.preferenceAmount, thousandSeparator: currency.getThousandsSeparatorOrDefault(), decimalSeparator: currency.getDecimalSeparatorOrDefault(), addingCurrencySymbol: currency.getCurrencySymbolOrDefault(), addingParenthesis: false)
        let itemsData = OneTapHeaderSummaryData("Tu compra", itemsAmountString, ThemeManager.shared.greyColor(), false)
        data.append(itemsData)

        // Add discount row data
        if self.hasDiscount(), let discount = self.amountHelper.discount, let discountAmount = discount.getDiscountAmount() {
            let discountAmountString = Utils.getAmountFormatted(amount: discountAmount, thousandSeparator: currency.getThousandsSeparatorOrDefault(), decimalSeparator: currency.getDecimalSeparatorOrDefault(), addingCurrencySymbol: currency.getCurrencySymbolOrDefault(), addingParenthesis: false)
            let discountData = OneTapHeaderSummaryData(discount.getDiscountDescription(), discountAmountString, ThemeManager.shared.noTaxAndDiscountLabelTintColor(), false)
            data.append(discountData)
        }

        // Add total row data
        let totalAmountString = Utils.getAmountFormatted(amount: self.amountHelper.amountToPay, thousandSeparator: currency.getThousandsSeparatorOrDefault(), decimalSeparator: currency.getDecimalSeparatorOrDefault(), addingCurrencySymbol: currency.getCurrencySymbolOrDefault(), addingParenthesis: false)
        let totalData = OneTapHeaderSummaryData("Total".localized, totalAmountString, UIColor.black, true)
        data.append(totalData)


//        let viewModel = PXOneTapHeaderViewModel(icon: PXUIImage(url: "https://ih0.redbubble.net/image.491854097.6059/flat,550x550,075,f.u2.jpg"), title: "Burger King", data: [
//            OneTapHeaderSummaryData("Tu compra", "$ 1.000", ThemeManager.shared.greyColor(), false),
//            OneTapHeaderSummaryData("20% Descuento por usar QR", "- $ 200", ThemeManager.shared.noTaxAndDiscountLabelTintColor(), false),
//            OneTapHeaderSummaryData("Total", "$ 1100", UIColor.black, true)
//            ])

        let viewModel = PXOneTapHeaderViewModel(icon: getImage(), title: getTitle(), data: data)

        return viewModel
    }

    func getTitle() -> String {
        if reviewScreenPreference.hasItemsEnabled(), let item = self.amountHelper.preference.items.first {
            return item.getTitle()
        }
        // TODO: Return default title
        return ""
    }

    func getImage() -> UIImage {
        if reviewScreenPreference.hasItemsEnabled(), let item = self.amountHelper.preference.items.first, let pictureURL = item.getPictureURL() {
            return PXUIImage(url: pictureURL, placeholder: "default_item_icon", fallback: "default_item_icon")
        }
        return ResourceManager.shared.getImage("default_item_icon")!
    }
}
