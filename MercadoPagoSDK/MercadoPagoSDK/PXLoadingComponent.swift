//
//  PXLoadingComponent.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 5/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit
import MLUI

final class PXLoadingComponent {

    static let shared = PXLoadingComponent()

    private lazy var loadingContainer = UIView()
    private lazy var backgroundColor = ThemeManager.shared.loadingComponent().backgroundColor
    private lazy var tintColor = ThemeManager.shared.loadingComponent().tintColor

    func showInView(_ view: UIView) -> UIView {

        let spnConfig = MLSpinnerConfig(size: .big, primaryColor: tintColor, secondaryColor: tintColor)
        let spinner = MLSpinner(config: spnConfig, text: nil)

        loadingContainer = UIView()
        loadingContainer.frame = view.frame
        loadingContainer.addSubview(spinner)

        PXLayout.centerHorizontally(view: spinner).isActive = true
        PXLayout.centerVertically(view: spinner).isActive = true

        spinner.show()

        view.backgroundColor = backgroundColor
        loadingContainer.backgroundColor = backgroundColor

        view.addSubview(loadingContainer)
        view.bringSubview(toFront: loadingContainer)

        return loadingContainer
    }

    func hide() {
        loadingContainer.removeFromSuperview()
    }
}
