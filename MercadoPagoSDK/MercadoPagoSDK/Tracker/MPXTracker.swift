//
//  MPXTracker.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 6/1/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

protocol MPXTracker {
    static var mpxPublicKey: String {get}
    static var mpxCheckoutVersion: String {get}
    static var mpxPlatform: String {get}
    static var mpxSiteId: String {get}
    static var mpxPlatformType: String {get}
}

extension MPXTracker {
    static func trackScreen(screenId: String, screenName: String) {
        let screenTrack = ScreenTrackInfo(screenName: screenName, screenId: screenId)
        TrackStorageManager.persist(screenTrackInfo: screenTrack)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            attemptToTrack()
        })
    }
    static func canSendTrack() -> Bool {
        let status = Reach().connectionStatus()
        if status.description == "Offline" {
            return false
        }
        return status.description == "Online (WiFi)" || UIApplication.shared.applicationState == UIApplicationState.background
    }

    static func attemptToTrack() {
        let array = TrackStorageManager.getBatchScreenTracks()
        if array.count == 0 {
            return
        }
        if canSendTrack() {
           send(trackList: TrackStorageManager.getBatchScreenTracks())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                attemptToTrack()
            })

        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                attemptToTrack()
            })
        }
    }
    static private func send(trackList: Array<ScreenTrackInfo>) {
        var jsonBody = generateJSONDefault()
        var arrayEvents = Array<[String:Any]>()
        for elementToTrack in trackList {
            arrayEvents.append(elementToTrack.toJSON())
        }
        jsonBody["events"] = arrayEvents
        let body = JSONHandler.jsonCoding(jsonBody)
        self.request(url: "https://api.mercadopago.com/beta/checkout/tracking/events", params: nil, body: body, method: "POST", headers: nil, success: { (result) -> Void in
            print("TRACKED!")
        }) { (error) -> Void in
            TrackStorageManager.persist(screenTrackInfoArray: trackList) // Vuelve a guardar los tracks que no se pudieron trackear
        }
    }
    static private func generateJSONDefault() -> [String:Any] {
        let clientId = UIDevice.current.identifierForVendor!.uuidString
        let deviceJSON = MPTDevice().toJSON()
        let applicationJSON = MPTApplication(publicKey: mpxPublicKey, checkoutVersion: mpxCheckoutVersion, platform: mpxPlatform).toJSON()
        let obj: [String:Any] = [
            "client_id": clientId,
            "application": applicationJSON,
            "device": deviceJSON,
            ]
        return obj
    }
    static func request(url: String, params: String?, body: String? = nil, method: String, headers: [String:String]? = nil, success: @escaping (Any) -> Void,
                              failure: ((NSError) -> Void)?) {
        var requesturl = url
        if params != nil && !(params?.isEmpty)! {
            requesturl += "?" + params!
        }
        let finalURL: NSURL = NSURL(string: url)!
        let request: NSMutableURLRequest
        request = NSMutableURLRequest(url: finalURL as URL)
        request.url = finalURL as URL
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if headers !=  nil && headers!.count > 0 {
            for header in headers! {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        if let body = body {
            request.httpBody = body.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        }
        var session = URLSession.shared
        var task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                do {
                    let responseJson = try JSONSerialization.jsonObject(with: data!,
                                                                        options:JSONSerialization.ReadingOptions.allowFragments)
                    if let paymentDic = responseJson as? NSDictionary {
                        if paymentDic["status"] as? Int == 200 {
                            print("200!")
                        }else {
                            print("Codigo = \(paymentDic["status"])")
                        }
                    }
                    success(responseJson as Any)
                } catch {
                    let e: NSError = NSError(domain: "com.mercadopago.sdk", code: NSURLErrorCannotDecodeContentData, userInfo: nil)
                    failure?(e)
                }
            } else {
                if failure != nil {
                    failure!(error! as NSError)
                }
            }})

        task.resume()
    }
}
