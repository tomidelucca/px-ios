//
//  MercadoPagoCheckout+Tracking.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 13/12/2018.
//

import Foundation

// MARK: Tracking
extension MercadoPagoCheckout {

    internal func startTracking() {
        MPXTracker.sharedInstance.setPublicKey(viewModel.publicKey)
        MPXTracker.sharedInstance.startNewFlow()

        // Track init event
        var properties: [String: Any] = [:]
        if !String.isNullOrEmpty(viewModel.checkoutPreference.id) {
        properties["checkout_preference_id"] = viewModel.checkoutPreference.id
        } else {
        properties["checkout_preference"] = viewModel.checkoutPreference.getCheckoutPrefForTracking()
        }

        properties["esc_enabled"] = viewModel.getAdvancedConfiguration().escEnabled
        properties["express_enabled"] = viewModel.getAdvancedConfiguration().expressEnabled

        MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.getInitPath(), properties: properties)
    }
}
