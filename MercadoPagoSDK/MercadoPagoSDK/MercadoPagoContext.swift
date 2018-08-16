//
//  MercadoPagoContext.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

/** :nodoc: */
//TODO: v4 sign - Ver si lo usamos/exponemos.
@objcMembers open class MercadoPagoContext: NSObject {

    static let sharedInstance = MercadoPagoContext()

    var public_key: String = ""

    var payer_access_token: String = ""

    var language: String = NSLocale.preferredLanguages[0]

    static let kSdkVersion = "sdk_version"

    open class func isAuthenticatedUser() -> Bool {
        return !sharedInstance.payer_access_token.isEmpty
    }
    static var mpxPublicKey: String {return sharedInstance.publicKey()}
    static var mpxCheckoutVersion: String {return sharedInstance.sdkVersion()}
    static var mpxPlatform: String {return sharedInstance.framework()}
    static var platformType: String {return "native/ios"}

    open func framework() -> String! {
        return  "iOS"
    }

    open func sdkVersion() -> String {
        let sdkVersion: String = Utils.getSetting(identifier: MercadoPagoContext.kSdkVersion) ?? ""
        return sdkVersion
    }

    open static func setLanguage(language: Languages) {
        sharedInstance.language = language.langPrefix()
    }

    open static func setLanguage(string: String) {
        var languange = string
        if String.isNullOrEmpty(string) {
            languange = "es"
        }
        sharedInstance.language = languange
    }

    open static func getLanguage() -> String {
        return sharedInstance.language
    }

    open static func getLocalizedID() -> String {
        let bundle = MercadoPago.getBundle() ?? Bundle.main

        let currentLanguage = MercadoPagoContext.getLanguage()
        let currentLanguageSeparated = currentLanguage.components(separatedBy: "-")[0]
        if bundle.path(forResource: currentLanguage, ofType: "lproj") != nil {
            return currentLanguage
        } else if (bundle.path(forResource: currentLanguageSeparated, ofType: "lproj") != nil) {
            return currentLanguageSeparated
        } else {
            return "es"
        }
    }

    open static func getParentLanguageID() -> String {
        return MercadoPagoContext.getLanguage().components(separatedBy: "-")[0]
    }

    open static func getLocalizedPath() -> String {
        let bundle = MercadoPago.getBundle() ?? Bundle.main
        let pathID = getLocalizedID()
        return bundle.path(forResource: pathID, ofType: "lproj")!
    }

    open static func getParentLocalizedPath() -> String {
        let bundle = MercadoPago.getBundle() ?? Bundle.main
        let pathID = getParentLanguageID()
        return bundle.path(forResource: pathID, ofType: "lproj")!
    }

    open func publicKey() -> String! {
        return self.public_key
    }

    fileprivate override init() {
        super.init()
    }

    open class func setPayerAccessToken(_ payerAccessToken: String) {
        sharedInstance.payer_access_token = payerAccessToken.trimSpaces()
    }

    open class func setPublicKey(_ public_key: String) {
        sharedInstance.public_key = public_key.trimSpaces()
    }

    open class func publicKey() -> String {
        return sharedInstance.public_key
    }

    open class func payerAccessToken() -> String {
        return sharedInstance.payer_access_token
    }
}
