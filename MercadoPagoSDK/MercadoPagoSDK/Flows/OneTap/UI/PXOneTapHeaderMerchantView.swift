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
    private var showHorizontally: Bool
    private var horizontalLayoutConstraints: [NSLayoutConstraint] = []
    private var verticalLayoutConstraints: [NSLayoutConstraint] = []

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
        } else if UIDevice.isLargeDevice() || UIDevice.isExtraLargeDevice() {
            return 65
        } else {
            return 55
        }
    }

    private func render() {
        let containerView = UIView()
        let imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.dropShadow(radius: 2, opacity: 0.15)

        let imageView = PXUIImageView()
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = IMAGE_SIZE/2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.enableFadeIn()
        imageView.backgroundColor = .white
        imageView.image = image
        imageContainerView.addSubview(imageView)

        PXLayout.pinTop(view: imageView).isActive = true
        PXLayout.pinBottom(view: imageView).isActive = true
        PXLayout.pinLeft(view: imageView).isActive = true
        PXLayout.pinRight(view: imageView).isActive = true

        containerView.addSubview(imageContainerView)
        PXLayout.setHeight(owner: imageContainerView, height: IMAGE_SIZE).isActive = true
        PXLayout.setWidth(owner: imageContainerView, width: IMAGE_SIZE).isActive = true

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

        let horizontalConstraints = [PXLayout.pinTop(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.pinBottom(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.pinLeft(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.pinRight(view: titleLabel, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.put(view: imageContainerView, leftOf: titleLabel, withMargin: PXLayout.XXS_MARGIN, relation: .equal),
                                     PXLayout.centerVertically(view: imageContainerView, to: titleLabel)]

        horizontalLayoutConstraints.append(contentsOf: horizontalConstraints)

        let verticalConstraints = [PXLayout.centerHorizontally(view: imageContainerView),
                                   PXLayout.pinTop(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                   PXLayout.centerHorizontally(view: titleLabel),
                                   PXLayout.put(view: titleLabel, onBottomOf: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                   PXLayout.pinBottom(view: titleLabel, withMargin: PXLayout.XXS_MARGIN),
                                   PXLayout.matchWidth(ofView: containerView)]

        verticalLayoutConstraints.append(contentsOf: verticalConstraints)

        if showHorizontally {
            animateToHorizontal()
        } else {
            animateToVertical()
        }
    }

    func updateContentViewLayout() {
        self.layoutIfNeeded()
        if UIDevice.isLargeDevice() || UIDevice.isExtraLargeDevice() {
            self.pinContentViewToTop(margin: 24)
        } else if !UIDevice.isSmallDevice() {
            self.pinContentViewToTop()
        }
    }

    func animateToVertical(duration: Double = 0) {
        self.layoutIfNeeded()
        var pxAnimator = PXAnimator(duration: duration, dampingRatio: 1)
        pxAnimator.addAnimation(animation: { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.layoutIfNeeded()

            strongSelf.updateContentViewLayout()

            for constraint in strongSelf.horizontalLayoutConstraints {
                constraint.isActive = false
            }

            for constraint in strongSelf.verticalLayoutConstraints {
                constraint.isActive = true
            }
            strongSelf.layoutIfNeeded()
        })

        pxAnimator.animate()
    }

    func animateToHorizontal(duration: Double = 0) {
        self.layoutIfNeeded()
        var pxAnimator = PXAnimator(duration: duration, dampingRatio: 1)
        pxAnimator.addAnimation(animation: { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.layoutIfNeeded()
            strongSelf.pinContentViewToTop()
            for constraint in strongSelf.horizontalLayoutConstraints {
                constraint.isActive = true
            }

            for constraint in strongSelf.verticalLayoutConstraints {
                constraint.isActive = false
            }
            strongSelf.layoutIfNeeded()
        })

        pxAnimator.animate()
    }
}
