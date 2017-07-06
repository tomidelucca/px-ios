//
//  File.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 7/5/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

protocol TrackingStrategy {
    func trackScreen(screenTrack: ScreenTrackInfo)
}

class PersistAndTrack: TrackingStrategy {

    var attemptSendForEachTrack = true

    init(attemptSendEachTrack: Bool = true) {
        self.attemptSendForEachTrack = attemptSendEachTrack
    }

    func trackScreen(screenTrack: ScreenTrackInfo) {
        TrackStorageManager.persist(screenTrackInfo: screenTrack)
        if attemptSendForEachTrack {
            attemptSendTrackInfo()
        }
    }

    func canSendTrack() -> Bool {
        let status = Reach().connectionStatus()
        if status.description == "Offline" {
            return false
        }
        return status.description == "Online (WiFi)" || UIApplication.shared.applicationState == UIApplicationState.background
    }

    func attemptSendTrackInfo() {
        if canSendTrack() {
            let array = TrackStorageManager.getBatchScreenTracks()
            guard let batch = array else {
                return
            }
            send(trackList: batch)
            attemptSendTrackInfo()
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
                self.attemptSendTrackInfo()
            })
        }
    }
    private func send(trackList: Array<ScreenTrackInfo>) {
        var jsonBody = MPXTracker.generateJSONDefault()
        var arrayEvents = Array<[String:Any]>()
        for elementToTrack in trackList {
            arrayEvents.append(elementToTrack.toJSON())
        }
        jsonBody["events"] = arrayEvents
        let body = JSONHandler.jsonCoding(jsonBody)
        TrackingServices.request(url: "https://api.mercadopago.com/beta/checkout/tracking/events", params: nil, body: body, method: "POST", headers: nil, success: { (result) -> Void in
            print("TRACKED!")
        }) { (error) -> Void in
            TrackStorageManager.persist(screenTrackInfoArray: trackList) // Vuelve a guardar los tracks que no se pudieron trackear
        }
    }

}
