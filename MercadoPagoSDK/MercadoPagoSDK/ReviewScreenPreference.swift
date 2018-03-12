//
//  ReviewScreenPreference.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 2/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

open class ReviewScreenPreference: NSObject {

    private var title = "Revisa si está todo bien"
    private var confirmButtonText = "Pagar"
    private var cancelButtonText = "Cancelar Pago"
	private var shouldDisplayChangeMethodOption = true
    var details: [SummaryType: SummaryDetail] = [SummaryType: SummaryDetail]()
    var disclaimer: String?
    var disclaimerColor: UIColor = ThemeManager.shared.getTheme().noTaxAndDiscountLabelTintColor()
    var showSubitle: Bool = false
    let summaryTitles: [SummaryType: String] = [SummaryType.PRODUCT: "Producto".localized, SummaryType.ARREARS: "Mora".localized, SummaryType.CHARGE: "Cargos".localized,
                                                            SummaryType.DISCOUNT: "Descuentos".localized, SummaryType.TAXES: "Impuestos".localized, SummaryType.SHIPPING: "Envío".localized]
    private var itemsReview: ItemsReview = ItemsReview()
    var collectorIcon: UIImage?
    static let DEFAULT_AMOUNT_TITLE = "Precio Unitario: ".localized
    static let  DEFAULT_QUANTITY_TITLE = "Cantidad: ".localized
    var shouldShowQuantityRow: Bool = true
    var itemsEnable = true
    
    private var topCustomComponent: PXCustomComponentizable?
    private var bottomCustomComponent: PXCustomComponentizable?
    
    open func setPaymentMethodTopCustomComponent(_ component: PXCustomComponentizable) {
        self.topCustomComponent = component
    }
    open func setPaymentMethodBottomCustomComponent(_ component: PXCustomComponentizable) {
        self.bottomCustomComponent = component
    }
    open func getPaymentMethodTopCustomComponent() -> PXCustomComponentizable? {
        return self.topCustomComponent
    }
    open func getPaymentMethodBottomCustomComponent() -> PXCustomComponentizable? {
        return self.bottomCustomComponent
    }

    open func setConfirmButtonText(confirmButtonText: String) {
        self.confirmButtonText = confirmButtonText
    }

    open func getConfirmButtonText() -> String {
        return confirmButtonText.localized
    }

    open func setCancelButtonText(cancelButtonText: String) {
        self.cancelButtonText = cancelButtonText
    }

    open func getCancelButtonTitle() -> String {
        return cancelButtonText.localized
    }

	open func isChangeMethodOptionEnabled() -> Bool {
		return shouldDisplayChangeMethodOption
	}

	open func disableChangeMethodOption() {
		self.shouldDisplayChangeMethodOption = false
	}

	open func enableChangeMethodOption() {
		self.shouldDisplayChangeMethodOption = true
	}

    open func setCollectorIcon(image: UIImage){
        collectorIcon = image
    }

    open func getCollectorIcon() -> UIImage? {
        return collectorIcon
    }

    open func isItemsEnable() -> Bool {
        return itemsEnable
    }

    open func disableItems() {
        self.itemsEnable = false
    }

    open func enableItems() {
        self.itemsEnable = true
    }

    open func hideQuantityRow() {
        self.shouldShowQuantityRow = false
    }
    open func showQuantityRow() {
        self.shouldShowQuantityRow = true
    }
    var shouldShowAmountTitle: Bool = true
    open func hideAmountTitle() {
        self.shouldShowAmountTitle = false
    }
    open func showAmountTitle() {
        self.shouldShowAmountTitle = true
    }
    var quantityTitle = DEFAULT_QUANTITY_TITLE
    open func setQuantityTitle(title: String ) {
        if title.isEmpty {
            self.hideQuantityRow()
        }
        self.quantityTitle = title
    }
    open func getQuantityTitle() -> String {
        return quantityTitle
    }
    var amountTitle = DEFAULT_AMOUNT_TITLE
    open func setAmountTitle(title: String ) {
        self.amountTitle = title
    }
    open func getAmountTitle() -> String {
        return amountTitle
    }
    open func clearSummaryDetails() {
        self.details = [SummaryType: SummaryDetail]()
    }
}
