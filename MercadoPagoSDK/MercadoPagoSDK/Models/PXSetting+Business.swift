//
//  PXSetting+Business.swift
//  MercadoPagoSDKV4
//
//  Created by Eden Torres on 30/07/2018.
//

import Foundation
import MercadoPagoServicesV4
internal extension PXSetting {
    class func getSettingByBin(_ settings: [PXSetting]!, bin: String!) -> [PXSetting]? {
        var selectedSetting = [PXSetting] ()
        if settings != nil && settings.count > 0 {
            for setting in settings {
                if let settingBin = setting.bin {
                    if "" != bin && Regex(settingBin.pattern! + ".*").test(bin) &&
                        (String.isNullOrEmpty(settingBin.exclusionPattern) || !Regex(settingBin.exclusionPattern! + ".*").test(bin)) {
                        selectedSetting.append(setting)
                    }
                }
            }

        }
        return selectedSetting.isEmpty ? nil : selectedSetting
    }
}
