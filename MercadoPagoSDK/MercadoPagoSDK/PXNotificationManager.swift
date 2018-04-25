//
//  PXNotificationManager.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 25/4/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

struct PXNotificationManager {
    static fileprivate let attempToCloseNotification = Notification.Name(rawValue:"PXAttempToCloseNotification")
}

extension PXNotificationManager {
    struct suscribeTo {
        static func attempToCloseNotification(_ observer: Any, selector: Selector) {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(observer)
            notificationCenter.addObserver(observer, selector: selector, name: PXNotificationManager.attempToCloseNotification, object: nil)
        }
    }
}

extension PXNotificationManager {
    struct post  {
        static func attempToCloseNotification() {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: PXNotificationManager.attempToCloseNotification, object: nil)
        }
    }
}
