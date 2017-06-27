//
//  TrackStorageManager.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 6/27/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class TrackStorageManager: NSObject {

    static let SCREEN_TRACK_INFO_ARRAY_KEY = "screen-tracks-info"
    static func persist(screenTrackInfo: ScreenTrackInfo) {
        let arrayScreen = UserDefaults.standard.array(forKey: SCREEN_TRACK_INFO_ARRAY_KEY)
        var newArray = Array<Any>()
        if let array = arrayScreen {
            newArray.append(contentsOf: array)
        }
        newArray = [screenTrackInfo.toJSON()]
        UserDefaults.standard.setValue(newArray, forKey: SCREEN_TRACK_INFO_ARRAY_KEY)
    }
}
