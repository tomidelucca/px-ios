//
//  PXComponentContainerViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 11/8/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXComponentContainerViewController: MercadoPagoUIViewController {

    var scrollView: UIScrollView!
    var contentView = UIView()
    var heightComponent: NSLayoutConstraint!
    var lastViewConstraint: NSLayoutConstraint!

    init() {
        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(contentView)

        PXLayout.pinTop(view: contentView, to: scrollView).isActive = true
        PXLayout.centerHorizontally(view: contentView, to: scrollView).isActive = true
        PXLayout.matchWidth(ofView: contentView, toView: scrollView).isActive = true
        contentView.backgroundColor = .pxWhite
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(self.scrollView)

        PXLayout.pinLeft(view: scrollView, to: self.view).isActive = true
        PXLayout.pinRight(view: scrollView, to: self.view).isActive = true
        PXLayout.pinTop(view: scrollView, to: self.view).isActive = true

        var bottomDeltaMargin: CGFloat = 0
        // iPhoneX or any device with safe area inset > 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomSafeAreaInset = window?.safeAreaInsets.bottom
            if let bottomDeltaInset = bottomSafeAreaInset, bottomDeltaInset > 0 {
                bottomDeltaMargin = bottomDeltaInset
            }
        }
        PXLayout.pinBottom(view: scrollView, to: self.view, withMargin: -bottomDeltaMargin).isActive = true
        scrollView.bounces = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
