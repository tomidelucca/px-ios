//
//  PXTracker.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 30/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

@objcMembers
open class PXTracker: NSObject {
    open static func setListener(_ listener: PXTrackerListener) {
        MPXTracker.sharedInstance.setTrack(listener: listener)
    }
}
