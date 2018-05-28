//
//  PXOneTapViewModel+ItemComponent.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 16/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
extension PXOneTapViewModel {

    func getItemComponent() -> PXOneTapItemComponent? {

        let props = PXOneTapItemComponentProps(title: getIconTitle(), collectorImage: getCollectorIcon(), totalAmount: getTotalAmount(), amountWithoutDiscount: getAmountWithoutDiscount(), discountDescription: getDiscountDescription())
        return PXOneTapItemComponent(props: props)
    }

    private func getAmountWithoutDiscount() -> Double? {
        if MercadoPagoCheckoutViewModel.flowPreference.isDiscountEnable(), paymentData.discount != nil {
            return preference.getAmount()
        }
        return nil
    }

    private func getDiscountDescription() -> String? {
        if MercadoPagoCheckoutViewModel.flowPreference.isDiscountEnable(), let discount = paymentData.discount {
            return "\(discount.getDiscountDescription()) OFF"
        }
        return nil
    }

    private func getCollectorIcon() -> UIImage? {
        return reviewScreenPreference.getCollectorIcon()
    }

    private func getIconTitle() -> String {
        if preference.hasMultipleItems() {
            return "Productos".localized
        } else if let firstItemTitle = preference.items.first?.title {
            return firstItemTitle
        } else {
            return "Producto".localized
        }
    }
}
