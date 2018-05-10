//
//  PXTrackingUtil.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoPXTracking

extension TrackingUtil {
    //Screen IDs
    open static let SCREEN_ID_REVIEW_AND_CONFIRM_ONE_TAP = "/review_one_tap"

    // MARK: Action events
    open static let ACTION_ONE_TAP_CHANGE_PAYMENT_METHOD = "/one_tap_change"
    open static let ACTION_ONE_TAP_CHECKOUT_CANCEL = "/one_tap_cancel"
}
