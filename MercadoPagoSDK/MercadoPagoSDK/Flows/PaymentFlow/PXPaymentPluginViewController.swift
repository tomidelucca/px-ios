//
//  PXPaymentPluginViewController.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 3/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXPaymentPluginViewController: MercadoPagoUIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Temporary fix for MP/Meli UX incompatibility
        UIApplication.shared.statusBarStyle = .default
    }
}
