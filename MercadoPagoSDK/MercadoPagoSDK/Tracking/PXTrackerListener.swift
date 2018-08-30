//
//  PXTrackerListener.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 29/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

@objc public protocol PXTrackerListener: NSObjectProtocol {
    func trackScreen(screenName: String, extraParams: [String: Any]?)
    func trackEvent(screenName: String?, action: String!, result: String?, extraParams: [String: Any]?)
}
