//
//  CouponDetailViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 12/23/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoServices

final class CouponDetailViewController: MercadoPagoUIViewController {

    override open var screenName: String { return "DISCOUNT_SUMMARY" }

    private var amountHelper: PXAmountHelper

    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var discountTitle: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var totalAmount: UILabel!

    private let fontSize: CGFloat = 18.0
    private let baselineOffSet: Int = 6
    private let fontColor = ThemeManager.shared.boldLabelTintColor()
    private let discountFontColor = ThemeManager.shared.noTaxAndDiscountLabelTintColor()

    init(amountHelper: PXAmountHelper) {
        self.amountHelper = amountHelper
        super.init(nibName: "CouponDetailViewController", bundle: MercadoPago.getBundle())
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        populateDiscountData()
    }
}

// MARK: Coupon data
extension CouponDetailViewController {

    private func populateDiscountData() {
        guard let discount = self.amountHelper.discount else {
            return
        }
        totalTitle.text = "Total".localized
        productTitle.text = "Producto".localized
        productTitle.textColor = fontColor
        discountTitle.textColor = discountFontColor
        totalTitle.textColor = fontColor
        discountTitle.text = discount.concept
        let amount: Double = self.amountHelper.amountWithoutDiscount
        let currency = MercadoPagoContext.getCurrency()
        productAmount.attributedText = Utils.getAttributedAmount(amount, currency: currency, color: fontColor, fontSize: fontSize, baselineOffset: baselineOffSet)
        discountAmount.attributedText = Utils.getAttributedAmount(self.amountHelper.amountOff, currency: currency, color: discountFontColor, fontSize: fontSize, baselineOffset: baselineOffSet, negativeAmount: true)
        totalAmount.attributedText = Utils.getAttributedAmount( self.amountHelper.amountToPay , currency: currency, color: fontColor, fontSize: fontSize, baselineOffset: baselineOffSet)
    }
}
