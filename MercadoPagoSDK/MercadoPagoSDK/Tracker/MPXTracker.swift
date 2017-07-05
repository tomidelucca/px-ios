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

    static func trackScreen(screenId: String, screenName: String, attemptSend: Bool = false) {
        let screenTrack = ScreenTrackInfo(screenName: screenName, screenId: screenId)
        TrackStorageManager.persist(screenTrackInfo: screenTrack)
        if attemptSend {
            attemptSendTrackInfo()
        }
    }
    static func canSendTrack() -> Bool {
        let status = Reach().connectionStatus()
        if status.description == "Offline" {
            return false
        }
        return status.description == "Online (WiFi)" || UIApplication.shared.applicationState == UIApplicationState.background
    }

    static func attemptSendTrackInfo() {
        if canSendTrack() {
            let array = TrackStorageManager.getBatchScreenTracks()
            guard let batch = array else {
                return
            }
           send(trackList: batch)
           attemptSendTrackInfo()
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
                attemptSendTrackInfo()
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
    static func generateJSONScreen(screenId: String, screenName: String) -> [String:Any] {
        var obj = Self.generateJSONDefault()
        let screenJSON = Self.screenJSON(screenId: screenId, screenName: screenName)
        obj["events"] = [screenJSON]
        return obj
    }
    static func generateJSONEvent(screenId: String, screenName: String, action: String, category: String, label: String, value: String) -> [String:Any] {
        var obj = Self.generateJSONDefault()
        let eventJSON = Self.eventJSON(screenId: screenId, screenName: screenName, action: action, category: category, label: label, value: value)
        obj["events"] = [eventJSON]
        return obj
    }
    static func eventJSON(screenId: String, screenName: String, action: String, category: String, label: String, value: String) -> [String:Any] {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let timestamp = formatter.string(from: date).replacingOccurrences(of: " ", with: "T")
        let obj: [String:Any] = [
            "timestamp": timestamp,
            "type": "action",
            "screen_id": screenId,
            "screen_name": screenName,
            "action": action,
            "category": category,
            "label": label,
            "value": value
        ]
        return obj
    }
    static func screenJSON(screenId: String, screenName: String) -> [String:Any] {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let timestamp = formatter.string(from: date).replacingOccurrences(of: " ", with: "T")
        let obj: [String:Any] = [
            "timestamp": timestamp,
            "type": "screenview",
            "screen_id": screenId,
            "screen_name": screenName
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
                            failure!(NSError())
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
