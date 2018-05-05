//
//  PXLoadingComponent.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 5/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

final class PXLoadingComponent {

    static let shared = PXLoadingComponent()

    private lazy var loadingContainer = UIView()
    private lazy var backgroundColor = ThemeManager.shared.loadingComponent().backgroundColor
    private lazy var tintColor = ThemeManager.shared.loadingComponent().tintColor

    func showInView(_ view: UIView) -> UIView {

        view.backgroundColor = backgroundColor

        //loadingContainer = MPSDKLoadingView(loading: tintColor)!
        loadingContainer.backgroundColor = backgroundColor

        view.addSubview(loadingContainer)
        view.bringSubview(toFront: loadingContainer)

        return loadingContainer
    }

    func hideView() {
        loadingContainer.removeFromSuperview()
    }
}
