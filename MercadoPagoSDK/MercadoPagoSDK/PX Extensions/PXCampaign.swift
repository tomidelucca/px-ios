//
//  PXCampaign.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 15/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServicesV4

extension PXCampaign {
    internal static func filterCampaignsByCodeType(campaigns: [PXCampaign]?, _ codeType: String) -> [PXCampaign]? {
        if let campaigns = campaigns {
            let filteredCampaigns = campaigns.filter { (campaign: PXCampaign) -> Bool in
                return campaign.codeType == codeType
            }
            if filteredCampaigns.isEmpty {
                return nil
            }
            return filteredCampaigns
        }
        return nil
    }
}

internal enum CampaignCodeType: String {
    case NONE = "none"
    case SINGLE = "single"
    case MULTIPLE = "multiple"
}
