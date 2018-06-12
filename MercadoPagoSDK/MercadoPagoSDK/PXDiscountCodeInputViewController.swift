//
//  PXDiscountCodeInputViewController.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoServices

final class PXDiscountCodeInputViewController: MercadoPagoUIViewController, UITextFieldDelegate {

    override open var screenName: String { return "DISCOUNT_SUMMARY" }

    private let fontSize: CGFloat = PXLayout.S_FONT
    private let baselineOffSet: Int = 6
    private let fontColor = ThemeManager.shared.boldLabelTintColor()
    private let discountFontColor = ThemeManager.shared.noTaxAndDiscountLabelTintColor()
    private let currency = MercadoPagoContext.getCurrency()
    let contentView: PXComponentView = PXComponentView()
    private var textfield: HoshiTextField?
    private var errorLabel: UILabel?

    override open func viewDidLoad() {
        super.viewDidLoad()
        if self.contentView.isEmpty() {
            renderViews()
        }
    }
}

// MARK: Render Views
extension PXDiscountCodeInputViewController {

    private func renderViews() {
        let TITLE_LABEL_HEIGHT: CGFloat = 30
        let TEXTFIELD_HEIGHT: CGFloat = 35
        let ERROR_LABEL_HEIGHT: CGFloat = 16

        if let title = getTitle() {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.attributedText = title
            self.contentView.addSubviewToBottom(label, withMargin: PXLayout.XL_MARGIN)
            PXLayout.centerHorizontally(view: label).isActive = true
            PXLayout.pinLeft(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.setHeight(owner: label, height: TITLE_LABEL_HEIGHT).isActive = true
        }

        //Build input textfield
        let textfield = HoshiTextField()
        self.textfield = textfield
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.delegate = self
        textfield.autocapitalizationType = .allCharacters
        textfield.font = Utils.getFont(size: PXLayout.S_FONT)
        textfield.autocorrectionType = UITextAutocorrectionType.no
        self.contentView.addSubviewToBottom(textfield, withMargin: PXLayout.XXL_MARGIN)
        PXLayout.centerHorizontally(view: textfield).isActive = true
        PXLayout.pinLeft(view: textfield, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.pinRight(view: textfield, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.setHeight(owner: textfield, height: TEXTFIELD_HEIGHT).isActive = true

        //Build error Label
        let label = UILabel()
        self.errorLabel = label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.isHidden = true
        self.contentView.addSubviewToBottom(label, withMargin: PXLayout.XXXS_MARGIN)
        PXLayout.centerHorizontally(view: label).isActive = true
        PXLayout.pinLeft(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.pinRight(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.setHeight(owner: label, height: ERROR_LABEL_HEIGHT).isActive = true

        //Build action button
        let button = PXPrimaryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.buttonTitle = "Continuar"
        self.contentView.addSubviewToBottom(button, withMargin: PXLayout.S_MARGIN)
        PXLayout.centerHorizontally(view: button).isActive = true
        PXLayout.pinLeft(view: button, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.pinRight(view: button, withMargin: PXLayout.M_MARGIN).isActive = true
        button.add(for: .touchUpInside) {
            let activeDiscountAttributes = [NSAttributedStringKey.font: Utils.getLightFont(size: PXLayout.XXXS_FONT),
                                            NSAttributedStringKey.foregroundColor: ThemeManager.shared.rejectedColor()]

            let string = "Revisa este dato"
            let attributedString = NSMutableAttributedString(string: string, attributes: activeDiscountAttributes)
            self.showError(with: attributedString)
        }

        self.contentView.pinLastSubviewToBottom(withMargin: PXLayout.M_MARGIN)?.isActive = true
        self.view.addSubview(contentView)
        PXLayout.matchWidth(ofView: contentView).isActive = true
        PXLayout.matchHeight(ofView: contentView).isActive = true
        PXLayout.centerHorizontally(view: contentView).isActive = true
        PXLayout.centerVertically(view: contentView).isActive = true

        self.hideError()
    }

    func getTitle() -> NSAttributedString? {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let activeDiscountAttributes = [NSAttributedStringKey.font: Utils.getLightFont(size: PXLayout.L_FONT),
                                        NSAttributedStringKey.foregroundColor: ThemeManager.shared.boldLabelTintColor(),
                                        NSAttributedStringKey.paragraphStyle: paragraph]

        let string = "Ingresa tu cupón"
        let attributedString = NSMutableAttributedString(string: string, attributes: activeDiscountAttributes)
        return attributedString
    }

    func showError(with text: NSAttributedString) {
        if let textfield = textfield {
            textfield.borderInactiveColor = ThemeManager.shared.rejectedColor()
            textfield.borderActiveColor = ThemeManager.shared.rejectedColor()
            textfield.setNeedsDisplay()
            textfield.resignFirstResponder()
            textfield.becomeFirstResponder()
        }
        if let errorLabel = errorLabel {
            errorLabel.attributedText = text
            errorLabel.isHidden = false
        }
    }

    func hideError() {
        if let textfield = textfield {
            textfield.borderInactiveColor = ThemeManager.shared.secondaryColor()
            textfield.borderActiveColor = ThemeManager.shared.secondaryColor()
            textfield.setNeedsDisplay()
            textfield.resignFirstResponder()
            textfield.becomeFirstResponder()
        }
        if let errorLabel = errorLabel {
            errorLabel.isHidden = true
        }
    }
}

// MARK: Services
extension PXDiscountCodeInputViewController {

    func getCodeDiscount(with code: String) {
        if let mercadoPagoCheckout = MercadoPagoCheckout.currentCheckout {
            mercadoPagoCheckout.viewModel.mercadoPagoServicesAdapter.getCodeDiscount(amount: mercadoPagoCheckout.viewModel.amountHelper.amountToPay, payerEmail: mercadoPagoCheckout.viewModel.checkoutPreference.payer.email, couponCode: code, callback: { [weak self] (discount) in

//                guard let strongSelf = self else {
//                    return
//                }

                }, failure: { [weak self] _ in

//                    guard let strongSelf = self else {
//                        return
//                    }
//
//                    strongSelf.executeNextStep()
            })
        }
    }

}
