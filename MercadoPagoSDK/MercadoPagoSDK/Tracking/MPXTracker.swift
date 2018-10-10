//
//  MPXTracker.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 6/1/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

internal struct MPXTrackingEnvironment {
    public static let production = "production"
    public static let staging = "staging"
}

@objc
internal class MPXTracker: NSObject {
    @objc internal static let sharedInstance = MPXTracker()

    internal static let kTrackingSettings = "tracking_settings"
    internal var public_key: String = ""
    internal var sdkVersion = Utils.getSetting(identifier: "sdk_version") ?? ""

    private static let kTrackingEnabled = "tracking_enabled"
    private var trackListener: PXTrackerListener?
    private var flowService: FlowService = FlowService()
    private lazy var currentEnvironment: String = MPXTrackingEnvironment.production
}

// MARK: Getters/setters.
internal extension MPXTracker {
    internal func setPublicKey(_ public_key: String) {
        self.public_key = public_key.trimSpaces()
    }

    internal func getPublicKey() -> String {
        return self.public_key
    }

    internal func setEnvironment(environment: String) {
        self.currentEnvironment = environment
    }

    internal func getSdkVersion() -> String {
        return sdkVersion
    }

    internal func getPlatformType() -> String {
        return "/mobile/ios"
    }

    internal func isEnabled() -> Bool {
        guard let trackiSettings: [String: Any] = TrackingUtils.getSetting(identifier: MPXTracker.kTrackingSettings) else {
            return false
        }
        guard let trackingEnabled = trackiSettings[MPXTracker.kTrackingEnabled] as? Bool else {
            return false
        }
        return trackingEnabled
    }

    internal func setTrack(listener: PXTrackerListener) {
        trackListener = listener
    }

    internal func startNewFlow() {
        flowService.startNewFlow()
    }

    internal func startNewFlow(externalFlowId: String) {
        flowService.startNewFlow(externalFlowId: externalFlowId)
    }

    internal func getFlowID() -> String {
        return flowService.getFlowId()
    }
}

// MARK: Public interfase.
internal extension MPXTracker {
    internal func trackScreen(screenName: String, properties: [String: String] = [:]) {
        var screenPath = screenName
        if !screenName.startsWith("/wallet_error") {
            screenPath = "/px_checkout\(screenPath)"
        }
        if let trackListenerInterfase = trackListener {
            trackListenerInterfase.trackScreen(screenName: screenPath, extraParams: properties)
        }
    }

    internal func trackActionEvent(action: String, screenId: String, screenName: String, properties: [String: String] = [:]) {

    }
}
