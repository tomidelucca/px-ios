//
//  PXDiscountConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 10/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

internal typealias PXDiscountConfigurationType = (discount: PXDiscount?, campaign: PXCampaign?, isNotAvailable: Bool)

/**
 Configuration related to Mercadopago discounts and campaigns. More details: `PXDiscount` and `PXCampaign`.
 */
@objcMembers
open class PXDiscountConfiguration: NSObject, Codable {
    private var discount: PXDiscount?
    private var campaign: PXCampaign?
    private var isNotAvailable: Bool = false
    internal var discountToken: Int64?

    internal override init() {
        self.discount = nil
        self.campaign = nil
        isNotAvailable = true
    }

    /**
     Set Mercado Pago discount that will be applied to total amount.
     When you set a discount with its campaign, we do not check in discount service.
     You have to set a payment processor for discount be applied.
     - parameter discount: Mercado Pago discount.
     - parameter campaign: Discount campaign with discount data.
     */
    public init(discount: PXDiscount, campaign: PXCampaign) {
        self.discount = discount
        self.campaign = campaign
    }

    internal init(discount: PXDiscount?, campaign: PXCampaign?, isNotAvailable: Bool, token: Int64?) {
        self.discount = discount
        self.campaign = campaign
        self.isNotAvailable = isNotAvailable
        self.discountToken = token
    }

    public enum PXDiscountConfigurationKeys: String, CodingKey {
        case discount
        case campaign
        case isAvailable =  "is_available"
        case discountToken = "discount_token"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXDiscountConfigurationKeys.self)
        let discount: PXDiscount? = try container.decodeIfPresent(PXDiscount.self, forKey: .discount)
        let campaign: PXCampaign? = try container.decodeIfPresent(PXCampaign.self, forKey: .campaign)
        let token: Int64? = try container.decodeIfPresent(Int64.self, forKey: .discountToken)
        let isAvailable: Bool = try container.decode(Bool.self, forKey: .isAvailable)
        self.init(discount: discount, campaign: campaign, isNotAvailable: !isAvailable, token: token)
    }

    /**
     When you have the user have wasted all the discounts available
     this kind of configuration will show a generic message to the user.
     */
    public static func initForNotAvailableDiscount() -> PXDiscountConfiguration {
        return PXDiscountConfiguration()
    }
}

// MARK: - Internals
extension PXDiscountConfiguration {
    internal func getDiscountConfiguration() -> PXDiscountConfigurationType {
        return (discount, campaign, isNotAvailable)
    }
}
