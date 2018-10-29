//
//  PXOneTapHeaderMerchantView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/10/18.
//

import UIKit

class PXOneTapHeaderMerchantView: PXComponentView {
    let image: UIImage
    let title: String
    let showHorizontally: Bool

    init(image: UIImage, title: String, showHorizontally: Bool) {
        self.image = image
        self.title = title
        self.showHorizontally = showHorizontally
        super.init()
        render()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var IMAGE_SIZE: CGFloat {
        if UIDevice.isSmallDevice() {
            return 40
        } else if UIDevice.isBigDevice() {
            return 65
        } else {
            return 55
        }
    }

    private func render() {
        let containerView = UIView()
        let imageView = PXUIImageView()
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = IMAGE_SIZE/2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.enableFadeIn()
        imageView.backgroundColor = .white
        imageView.image = image
        containerView.addSubview(imageView)
        PXLayout.setHeight(owner: imageView, height: IMAGE_SIZE).isActive = true
        PXLayout.setWidth(owner: imageView, width: IMAGE_SIZE).isActive = true

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = Utils.getSemiBoldFont(size: PXLayout.M_FONT)
        titleLabel.textColor = ThemeManager.shared.statusBarStyle() == UIStatusBarStyle.default ? UIColor.black : ThemeManager.shared.whiteColor()
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        self.addSubviewToBottom(containerView)
        PXLayout.pinBottom(view: containerView).isActive = true
        PXLayout.centerHorizontally(view: containerView).isActive = true

        if showHorizontally {
            self.pinContentViewToTop()
            PXLayout.pinTop(view: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinBottom(view: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinLeft(view: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinRight(view: titleLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.put(view: imageView, leftOf: titleLabel, withMargin: PXLayout.XXS_MARGIN, relation: .equal).isActive = true
            PXLayout.centerVertically(view: imageView, to: titleLabel).isActive = true
        } else {
            PXLayout.centerHorizontally(view: imageView).isActive = true
            PXLayout.pinTop(view: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.centerHorizontally(view: titleLabel).isActive = true
            PXLayout.put(view: titleLabel, onBottomOf: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinBottom(view: titleLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.matchWidth(ofView: containerView).isActive = true
        }
    }
}
