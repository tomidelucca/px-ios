//
//  PXUIImageView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

public class PXUIImageView: UIImageView {

    private var currentImage: UIImage?
    override public var image: UIImage? {
        set {
            loadImage(image: newValue)
        }
        get {
            return currentImage
        }
    }

    private func loadImage(image: UIImage?) {
        self.contentMode = .scaleAspectFill
        if let pxImage = image as? PXUIImage {
            let placeholder = buildPlaceholderView(image: pxImage)
            let fallback = buildFallbackView(image: pxImage)

            Utils().loadImageFromURLWithCache(withUrl: pxImage.url, targetView: self, placeholderView: placeholder, fallbackView: fallback) { newImage in
                self.currentImage = newImage
            }
        } else {
            self.currentImage = image
        }
    }

    private func buildPlaceholderView(image: PXUIImage) -> UIView? {
        if let placeholderString = image.placeholder {
            return buildLabel(with: placeholderString)
        } else {
            return buildSpinner()
        }
    }

    private func buildFallbackView(image: PXUIImage) -> UIView? {
        if let fallbackString = image.fallback {
            return buildLabel(with: fallbackString)
        } else {
            return buildSpinner()
        }
    }

    private func buildSpinner() -> UIView {
        let spinner = PXComponentFactory.SmallSpinner.new(color1: ThemeManager.shared.secondaryColor(), color2: ThemeManager.shared.secondaryColor())
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.show()
        return spinner
    }

    private func buildLabel(with text: String?) -> UILabel? {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Utils.getFont(size: PXLayout.XS_FONT)
        label.textColor = ThemeManager.shared.labelTintColor()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.text = text
        return label
    }
}
