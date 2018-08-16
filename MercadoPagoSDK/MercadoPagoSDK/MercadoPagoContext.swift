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
