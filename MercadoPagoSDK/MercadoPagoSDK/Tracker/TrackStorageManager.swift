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
    static let MAX_TRACKS_PER_REQUEST = 10
    static let MAX_DAYS_IN_STORAGE = 7
    
    //Guardo el ScreenTrackInfo serializado en el array del userDefaults, si el mismo no esta creado lo crea
    static func persist(screenTrackInfo: ScreenTrackInfo) {
        let arrayScreen = UserDefaults.standard.array(forKey: SCREEN_TRACK_INFO_ARRAY_KEY)
        var newArray = Array<Any>()
        if let array = arrayScreen {
            newArray.append(contentsOf: array)
        }
        newArray.append(screenTrackInfo.toJSON())
        UserDefaults.standard.setValue(newArray, forKey: SCREEN_TRACK_INFO_ARRAY_KEY)

    }
    
    //Devuevle un array con los MAX_TRACKS_PER_REQUEST ultimos screenstrackinfo serializadas y los elimina del array de userDefaults
    static func getBatchScreenTracks() -> Array<Any> {
        //
     
        return Array<Any>()
    }
}
