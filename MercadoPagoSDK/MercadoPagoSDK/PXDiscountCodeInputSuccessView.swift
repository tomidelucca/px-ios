//
//  PXDiscountCodeInputSuccessView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 13/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXDiscountCodeInputSuccessView: UIView {

    private var title: NSAttributedString?
    private var message: NSAttributedString?
    private var icon: UIImage?
    private var action: PXComponentAction?

    func setProps(title: NSAttributedString, message: NSAttributedString, icon: UIImage, action: PXComponentAction) {
        self.title = title
        self.message = message
        self.icon = icon
        self.action = action
        self.renderViews()
    }

    private func renderViews() {
        self.backgroundColor = .white

        let TITLE_LABEL_HEIGHT: CGFloat = 27
        let ICON_HEIGHT: CGFloat = 48

        //Build image view
        if let icon = icon {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = icon
            self.addSubview(imageView)
            PXLayout.centerHorizontally(view: imageView).isActive = true
            PXLayout.pinTop(view: imageView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.setHeight(owner: imageView, height: ICON_HEIGHT).isActive = true
            PXLayout.setWidth(owner: imageView, width: ICON_HEIGHT).isActive = true
        }

        //Build title
        if let title = title {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.attributedText = title
            self.addSubview(label)
            PXLayout.put(view: label, onBottomOfLastViewOf: self, withMargin: PXLayout.S_MARGIN)?.isActive = true
            PXLayout.centerHorizontally(view: label).isActive = true
            PXLayout.pinLeft(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.setHeight(owner: label, height: TITLE_LABEL_HEIGHT).isActive = true
        }

        //Build message
        if let message = message {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.attributedText = message
            self.addSubview(label)
            PXLayout.put(view: label, onBottomOfLastViewOf: self, withMargin: PXLayout.XS_MARGIN)?.isActive = true
            PXLayout.centerHorizontally(view: label).isActive = true
            PXLayout.pinLeft(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
        }

        if let action = action {
            //Build action button
            let button = PXPrimaryButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.buttonTitle = action.label
            self.addSubview(button)
            PXLayout.put(view: button, onBottomOfLastViewOf: self, withMargin: PXLayout.M_MARGIN)?.isActive = true
            PXLayout.centerHorizontally(view: button).isActive = true
            PXLayout.pinLeft(view: button, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: button, withMargin: PXLayout.M_MARGIN).isActive = true
            button.add(for: .touchUpInside) {
                action.action()
            }
            PXLayout.pinBottom(view: button, withMargin: PXLayout.M_MARGIN).isActive = true
        }
    }
}
