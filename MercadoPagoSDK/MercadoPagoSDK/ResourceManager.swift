//
//  ResourceManager.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 17/08/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
internal class ResourceManager {

    static let shared = ResourceManager()

    let DEFAULT_FONT_NAME = ".SFUIDisplay-Regular"

    func getBundle() -> Bundle? {
        return Bundle(for: ResourceManager.self)
    }

    func getImage(_ name: String?) -> UIImage? {
        guard let name = name, let bundle = ResourceManager.shared.getBundle() else {
            return nil
        }
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }

}

// MARK: Payment Method Resources
extension ResourceManager {
    func getImageForPaymentMethod(withDescription: String, defaultColor: Bool = false) -> UIImage? {

        let path = ResourceManager.shared.getBundle()!.path(forResource: "PaymentMethodSearch", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)
        var description = withDescription
        let tintColorForIcons = ThemeManager.shared.getTintColorForIcons()

        if defaultColor {
            description += "Azul"
        } else if PaymentType.allPaymentIDs.contains(description) || description == "cards" || description.contains("bolbradesco") {
            if tintColorForIcons == nil {
                description += "Azul"
            }
        }

        guard let itemSelected = dictPM?.value(forKey: description) as? NSDictionary else {
            return nil
        }

        let image = ResourceManager.shared.getImage(itemSelected.object(forKey: "image_name") as? String)

        if description == "credit_card" || description == "prepaid_card" || description == "debit_card" || description == "bank_transfer" || description == "ticket" || description == "cards" || description.contains("bolbradesco") {
            if let iconsTintColor = tintColorForIcons {
                return image?.imageWithOverlayTint(tintColor: iconsTintColor)
            }
            return image
        } else {
            return image
        }
    }

    func getImageFor(_ paymentMethod: PaymentMethod, forCell: Bool? = false) -> UIImage? {
        if forCell == true {
            return ResourceManager.shared.getImage(paymentMethod.paymentMethodId.lowercased())
        } else if let pmImage = ResourceManager.shared.getImage("icoTc_"+paymentMethod.paymentMethodId.lowercased()) {
            return pmImage
        } else {
            return ResourceManager.shared.getCardDefaultLogo()
        }
    }

    func getCardDefaultLogo() -> UIImage? {
        return ResourceManager.shared.getImage("icoTc_default")
    }

    func getColorFor(_ paymentMethod: PaymentMethod, settings: [Setting]?) -> UIColor {
        let path = ResourceManager.shared.getBundle()!.path(forResource: "PaymentMethod", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)

        if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId) as? NSDictionary {
            if let stringColor = pmConfig.value(forKey: "first_color") as? String {
                return UIColor.fromHex(stringColor)
            } else {
                return UIColor.cardDefaultColor()
            }
        } else if let setting = settings?[0] {
            if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId + "_" + String(setting.cardNumber.length)) as? NSDictionary {
                if let stringColor = pmConfig.value(forKey: "first_color") as? String {
                    return UIColor.fromHex(stringColor)
                } else {
                    return UIColor.cardDefaultColor()
                }
            }
        }
        return UIColor.cardDefaultColor()

    }

    func getLabelMaskFor(_ paymentMethod: PaymentMethod, settings: [Setting]?, forCell: Bool? = false) -> String {
        let path = ResourceManager.shared.getBundle()!.path(forResource: "PaymentMethod", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)

        let defaultMask = "XXXX XXXX XXXX XXXX"

        if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId) as? NSDictionary {
            let etMask = pmConfig.value(forKey: "label_mask") as? String
            return etMask ?? defaultMask
        } else if let setting = settings?[0] {
            if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId + "_" + String(setting.cardNumber.length)) as? NSDictionary {
                let etMask = pmConfig.value(forKey: "label_mask") as? String
                return etMask ?? defaultMask
            }
        }
        return defaultMask
    }

    func getEditTextMaskFor(_ paymentMethod: PaymentMethod, settings: [Setting]?, forCell: Bool? = false) -> String {
        let path = ResourceManager.shared.getBundle()!.path(forResource: "PaymentMethod", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)

        let defaultMask = "XXXX XXXX XXXX XXXX"

        if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId) as? NSDictionary {
            let etMask = pmConfig.value(forKey: "editText_mask") as? String
            return etMask ?? defaultMask
        } else if let setting = settings?[0] {
            if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId + "_" + String(setting.cardNumber.length)) as? NSDictionary {
                let etMask = pmConfig.value(forKey: "editText_mask") as? String
                return etMask ?? defaultMask
            }
        }
        return defaultMask
    }

    func getFontColorFor(_ paymentMethod: PaymentMethod, settings: [Setting]?) -> UIColor {
        let path = ResourceManager.shared.getBundle()!.path(forResource: "PaymentMethod", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)
        let defaultColor = MPLabel.defaultColorText

        if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId) as? NSDictionary {
            if let stringColor = pmConfig.value(forKey: "font_color") as? String {
                return UIColor.fromHex(stringColor)
            } else {
                return defaultColor
            }
        } else if let setting = settings?[0] {
            if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId + "_" + String(setting.cardNumber.length)) as? NSDictionary {
                if let stringColor = pmConfig.value(forKey: "font_color") as? String {
                    return UIColor.fromHex(stringColor)
                } else {
                    return defaultColor
                }            }
        }
        return defaultColor

    }

    func getEditingFontColorFor(_ paymentMethod: PaymentMethod, settings: [Setting]?) -> UIColor {
        let path = ResourceManager.shared.getBundle()!.path(forResource: "PaymentMethod", ofType: "plist")
        let dictPM = NSDictionary(contentsOfFile: path!)
        let defaultColor = MPLabel.highlightedColorText

        if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId) as? NSDictionary {
            if let stringColor = pmConfig.value(forKey: "editing_font_color") as? String {
                return UIColor.fromHex(stringColor)
            } else {
                return defaultColor
            }
        } else if let setting = settings?[0] {
            if let pmConfig = dictPM?.value(forKey: paymentMethod.paymentMethodId + "_" + String(setting.cardNumber.length)) as? NSDictionary {
                if let stringColor = pmConfig.value(forKey: "editing_font_color") as? String {
                    return UIColor.fromHex(stringColor)
                } else {
                    return defaultColor
                }
            }
        }
        return defaultColor

    }
}
