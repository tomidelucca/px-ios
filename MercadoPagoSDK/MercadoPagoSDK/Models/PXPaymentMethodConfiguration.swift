//
//  PXPaymentMethodConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/11/18.
//

import UIKit

class PXPaymentMethodConfiguration: NSObject {
    let paymentOptionID: String
    let paymentOptionsConfigurations: [PXPaymentOptionConfiguration]
    let selectedAmountConfiguration: String
    init(paymentOptionID: String, paymentOptionsConfigurations: [PXPaymentOptionConfiguration], selectedAmountConfiguration: String) {
        self.paymentOptionID = paymentOptionID
        self.paymentOptionsConfigurations = paymentOptionsConfigurations
        self.selectedAmountConfiguration = selectedAmountConfiguration
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherConfiguration = object as? PXPaymentMethodConfiguration else {
            return false
        }
        return paymentOptionID == otherConfiguration.paymentOptionID
    }
}

class PXPaymentOptionConfiguration: NSObject {
    let id: String
    let discountConfiguration: PXDiscountConfiguration?
    let payerCostConfiguration: PXPayerCostConfiguration?
    init(id: String, discountConfiguration: PXDiscountConfiguration? = nil, payerCostConfiguration: PXPayerCostConfiguration? = nil) {
        self.id = id
        self.discountConfiguration = discountConfiguration
        self.payerCostConfiguration = payerCostConfiguration
        super.init()
    }
}

class PXSummaryAmount: NSObject, Codable {
    let payercostConfigurations: [String:PXPayerCostConfiguration]
    let discountConfigurations: [String:PXDiscountConfiguration]
    let selectedAmountConfigurationId: String
    var selectedAmountConfiguration: PXPaymentOptionConfiguration {
        get {
            return PXPaymentOptionConfiguration(id: selectedAmountConfigurationId, discountConfiguration: discountConfigurations[selectedAmountConfigurationId], payerCostConfiguration: payercostConfigurations[selectedAmountConfigurationId])
        }
    }
    
    init(payercostConfigurations: [String:PXPayerCostConfiguration], discountConfigurations: [String:PXDiscountConfiguration], selectedAmountConfigurationId: String) {
        self.payercostConfigurations = payercostConfigurations
        self.discountConfigurations = discountConfigurations
        self.selectedAmountConfigurationId = selectedAmountConfigurationId
    }
    
    public enum PXSummaryAmountKeys: String, CodingKey {
        case payercostConfigurations = "payer_cost_configurations"
        case discountConfigurations = "discount_configurations"
        case  selectedAmountConfigurationId = "selected_amount_configuration"
    }
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXSummaryAmountKeys.self)
        
        let payercostConfigurations: [String:PXPayerCostConfiguration]? = try container.decodeIfPresent([String:PXPayerCostConfiguration].self, forKey: .payercostConfigurations)
        let discountConfigurations: [String:PXDiscountConfiguration]? = try container.decodeIfPresent([String:PXDiscountConfiguration].self, forKey: .discountConfigurations)
        let selectedAmountConfigurationId: String? = try container.decodeIfPresent(String.self, forKey: .selectedAmountConfigurationId)
        
        self.init(payercostConfigurations: payercostConfigurations!, discountConfigurations: discountConfigurations!, selectedAmountConfigurationId: selectedAmountConfigurationId!)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXSummaryAmountKeys.self)
        try container.encodeIfPresent(self.payercostConfigurations, forKey: .payercostConfigurations)
        try container.encodeIfPresent(self.discountConfigurations, forKey: .discountConfigurations)
        try container.encodeIfPresent(self.selectedAmountConfigurationId, forKey: .selectedAmountConfigurationId)
    }
    open func toJSONString() throws -> String? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }
    open func toJSON() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    open class func fromJSON(data: Data) throws -> PXSummaryAmount {
        return try JSONDecoder().decode(PXSummaryAmount.self, from: data)
    }
}
