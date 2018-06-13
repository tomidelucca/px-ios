//
//  PXNotificationManager.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 25/4/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

struct PXNotificationManager {

}

extension PXNotificationManager {
    struct SuscribeTo {
        static func attemptToClose(_ observer: Any, selector: Selector) {
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(observer, selector: selector, name: .attemptToClose, object: nil)
        }

        static func stopAnimatingButton(_ observer: Any, selector: Selector) {
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(observer, selector: selector, name: .stopAnimatingButton, object: nil)
        }
    }
}

extension PXNotificationManager {
    struct UnsuscribeTo {
        static func attemptToClose(_ observer: Any) {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(observer, name: .attemptToClose, object: nil)
        }

        static func stopAnimatingButton(_ observer: Any) {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(observer, name: .stopAnimatingButton, object: nil)
        }
    }
}

extension PXNotificationManager {
    struct Post {
        static func attemptToClose() {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: .attemptToClose, object: nil)
        }

        static func stopAnimatingButton() {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: .stopAnimatingButton, object: nil)
        }
    }
}

internal extension NSNotification.Name {
    static let attemptToClose = Notification.Name(rawValue: "PXAttemptToClose")
    static let stopAnimatingButton = Notification.Name(rawValue: "PXStopAnimatingButton ")
}
