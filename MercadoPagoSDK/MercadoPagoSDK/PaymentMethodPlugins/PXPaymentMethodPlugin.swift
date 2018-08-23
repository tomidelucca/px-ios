//
//  PXPaymentMethodPlugin.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 12/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

/** :nodoc: */
@objcMembers
open class PXPaymentMethodPlugin: NSObject {

    @objc public enum RemotePaymentStatus: Int {
        case APPROVED
        case REJECTED
    }

    @objc public enum DisplayOrder: Int {
        case TOP
        case BOTTOM
    }

    static let PAYMENT_METHOD_TYPE_ID = PaymentTypeId.PAYMENT_METHOD_PLUGIN.rawValue

    internal var paymentMethodPluginId: String
    internal var name: String
    internal var paymentMethodPluginDescription: String?
    internal var image: UIImage

    open var initPaymentMethodPlugin: (PXCheckoutStore, @escaping (_ success: Bool) -> Void) -> Void = {store, callback in
        callback(true)
    }

    internal var paymentMethodConfigPlugin: PXConfigPluginComponent?
    internal var displayOrder = DisplayOrder.TOP

    open var mustShowPaymentMethodPlugin: (PXCheckoutStore) -> Bool = {shouldShowPlugin in return true}

    public init (paymentMethodPluginId: String, name: String, image: UIImage, description: String?) {
        self.paymentMethodPluginId = paymentMethodPluginId
        self.name = name
        self.image = image
        self.paymentMethodPluginDescription = description
    }

    open func setPaymentMethodConfig(plugin: PXConfigPluginComponent) {
        self.paymentMethodConfigPlugin = plugin
    }

    open func setDisplayOrder(order: DisplayOrder) {
        self.displayOrder = order
    }
}

/** :nodoc: */
// MARK: PXPaymentMethodPlugin as PaymentOptionDrawable/PaymentMethodOption
extension PXPaymentMethodPlugin: PaymentMethodOption, PaymentOptionDrawable {
    public func getId() -> String {
        return paymentMethodPluginId
    }

    public func getDescription() -> String {
        return name
    }

    public func getComment() -> String {
        return ""
    }

    public func hasChildren() -> Bool {
        return false
    }

    public func getChildren() -> [PaymentMethodOption]? {
        return nil
    }

    public func isCard() -> Bool {
        return false
    }

    public func isCustomerPaymentMethod() -> Bool {
        return false
    }

    public func getImage() -> UIImage? {
        return image
    }

    public func getTitle() -> String {
        return name
    }

    public func getSubtitle() -> String? {
        return nil
    }

    public func setDescription(_ text: String?) {
        self.paymentMethodPluginDescription = text
    }
}
