//
//  PXTrackingUtil.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoPXTracking

//MARK: - Screens
extension TrackingUtil {
    //TODO: Revisar las screen id y name. (La semantica)
    enum ScreenId {
        static let REVIEW_AND_CONFIRM_ONE_TAP = "/express"
    }

    enum ScreenName {
        static let REVIEW_AND_CONFIRM_ONE_TAP = "ONE_TAP"
    }
}

//MARK: - Events
extension TrackingUtil {
    struct Event {
        //OLD: "/one_tap_change"
        static let TAP_CHANGE_PAYMENT_METHOD = "TAP_CHANGE_PAYMENT_METHOD"
        static let TAP_SUMMARY_DETAIL = "TAP_SUMMARY_DETAIL"
        static let TAP_BACK = "TAP_BACK"
        static let TAP_TC_DISCOUNT = "TAP_TC_DISCOUNT"
    }
}
