//
//  PXPaymentMethod+Business.swift
//  MercadoPagoSDKV4
//
//  Created by Eden Torres on 30/07/2018.
//

import Foundation
import MercadoPagoServicesV4
extension PXPaymentMethod: Cellable {

    var objectType: ObjectTypes {
        get {
            return ObjectTypes.paymentMethod
        }
        set {
            self.objectType = ObjectTypes.paymentMethod
        }
    }

    internal var isIssuerRequired: Bool {
        return isAdditionalInfoNeeded("issuer_id")
    }

    internal var isIdentificationRequired: Bool {
        if isAdditionalInfoNeeded("cardholder_identification_number") || isAdditionalInfoNeeded("identification_number") || isEntityTypeRequired {
            return true
        }
        return false
    }
    internal var isIdentificationTypeRequired: Bool {
        if isAdditionalInfoNeeded("cardholder_identification_type") || isAdditionalInfoNeeded("identification_type") || isEntityTypeRequired {
            return true
        }
        return false
    }

    internal var isPayerInfoRequired: Bool {
        if isAdditionalInfoNeeded("bolbradesco_name") || isAdditionalInfoNeeded("bolbradesco_identification_type") || isAdditionalInfoNeeded("bolbradesco_identification_number") {
            return true
        }
        return false
    }

    internal var isEntityTypeRequired: Bool {
        return isAdditionalInfoNeeded("entity_type")
    }

    internal var isCard: Bool {
        if let paymentTypeId = PaymentTypeId(rawValue: self.paymentTypeId) {
            return paymentTypeId.isCard()
        }
        return false
    }

    internal var isCreditCard: Bool {
        if let paymentTypeId = PaymentTypeId(rawValue: self.paymentTypeId) {
            return paymentTypeId.isCreditCard()
        }
        return false

    }

    internal var isPrepaidCard: Bool {
        if let paymentTypeId = PaymentTypeId(rawValue: self.paymentTypeId) {
            return paymentTypeId.isPrepaidCard()
        }
        return false
    }

    internal var isDebitCard: Bool {
        if let paymentTypeId = PaymentTypeId(rawValue: self.paymentTypeId) {
            return paymentTypeId.isDebitCard()
        }
        return false
    }

    internal func isSecurityCodeRequired(_ bin: String) -> Bool {
        let settings: [PXSetting]? = PXSetting.getSettingByBin(self.settings, bin: bin)
        if let setting = settings?.first, let securityCode = setting.securityCode {
            if securityCode.length != 0 {
                return true
            }
        }
        return false
    }

    internal func isAdditionalInfoNeeded(_ param: String!) -> Bool {
        if let additionalInfoNeeded = additionalInfoNeeded {
            for info in additionalInfoNeeded where info == param {
                return true
            }
        }
        return false
    }

    internal func conformsToBIN(_ bin: String) -> Bool {
        return (PXSetting.getSettingByBin(self.settings, bin: bin) != nil)
    }
    internal func cloneWithBIN(_ bin: String) -> PXPaymentMethod? {
        guard let setting = PXSetting.getSettingByBin(settings, bin: bin) else {
            return nil
        }
        let paymentMethod: PXPaymentMethod = PXPaymentMethod(additionalInfoNeeded: additionalInfoNeeded, id: paymentMethodId, name: name, paymentTypeId: paymentTypeId, status: status, secureThumbnail: secureThumbnail, thumbnail: thumbnail, deferredCapture: deferredCapture, settings: setting, minAllowedAmount: minAllowedAmount, maxAllowedAmount: maxAllowedAmount, accreditationTime: accreditationTime, merchantAccountId: merchantAccountId, financialInstitutions: financialInstitutions, description: paymentMethodDescription)
        paymentMethod.paymentMethodId = paymentMethodId
        paymentMethod.name = self.name
        paymentMethod.paymentTypeId = self.paymentTypeId
        paymentMethod.additionalInfoNeeded = self.additionalInfoNeeded
        return paymentMethod
    }

    internal var isAmex: Bool {
        return self.paymentMethodId == "amex"
    }

    internal var isAccountMoney: Bool {
        return self.paymentMethodId == PaymentTypeId.ACCOUNT_MONEY.rawValue
    }

    internal func secCodeMandatory() -> Bool {
        guard let firstSetting = settings.first, let firstSettingMode = firstSetting.securityCode?.mode  else {
            return false //Si no tiene settings el codigo de seguridad no es mandatorio
        }
        let filterList = settings.filter({ return $0.securityCode?.mode == firstSettingMode })
        if filterList.count == self.settings.count {
            return firstSetting.securityCode?.mode == "mandatory"
        } else {
            return true // si para alguna de sus settings es mandatorio entonces el codigo es mandatorio
        }
    }

    internal func secCodeLenght(_ bin: String? = nil) -> Int {
        if let bin = bin {
            var binSettings: [PXSetting]? = nil
            binSettings = PXSetting.getSettingByBin(self.settings, bin: bin)
            if let firstSetting = binSettings?.first {
                return firstSetting.securityCode?.length ?? 3
            }
        }
        if let setting = settings.first, let securityCode = setting.securityCode {
            return securityCode.length
        }
        return 3
    }

    open func cardNumberLenght() -> Int {
        guard let firstSetting = settings.first, let firstSettingCardLength = firstSetting.cardNumber?.length else {
            return 0 //Si no tiene settings la longitud es cero
        }

        let filterList = settings.filter({ return $0.cardNumber?.length == firstSettingCardLength })
        if filterList.count == self.settings.count {
            return firstSettingCardLength
        } else {
            return 0 //si la longitud de sus numberos, en sus settings no es siempre la misma entonces responde 0
        }
    }

    open func secCodeInBack() -> Bool {
        guard let firstSetting = settings.first, let firstSettingCardLocation = firstSetting.securityCode?.cardLocation else {
            return true //si no tiene settings, por defecto el codigo de seguridad ira atras
        }

        let filterList = settings.filter({ return $0.securityCode?.cardLocation == firstSettingCardLocation })
        if filterList.count == self.settings.count {
            return firstSettingCardLocation == "back"
        } else {
            return true //si sus settings no coinciden el codigo ira atras por default
        }
    }

    open var isOnlinePaymentMethod: Bool {
        return self.isCard || self.isAccountMoney
    }

    internal func conformsPaymentPreferences(_ paymentPreference: PaymentPreference?) -> Bool {

        if paymentPreference == nil {
            return true
        }
        if paymentPreference!.defaultPaymentMethodId != nil {
            if paymentMethodId != paymentPreference!.defaultPaymentMethodId {
                return false
            }
        }
        if let excludedPaymentTypeIds = paymentPreference?.excludedPaymentTypeIds {
            for excludedPaymentType in excludedPaymentTypeIds where excludedPaymentType == self.paymentTypeId {
                return false
            }
        }

        if let excludedPaymentMethodIds = paymentPreference?.excludedPaymentMethodIds {
            for excludedPaymentMethodId  in excludedPaymentMethodIds where excludedPaymentMethodId == paymentMethodId {
                return false
            }
        }

        if paymentPreference!.defaultPaymentTypeId != nil {
            if paymentPreference!.defaultPaymentTypeId != self.paymentTypeId {
                return false
            }
        }

        return true
    }

    // IMAGE
    internal func getImage() -> UIImage? {
        return MercadoPago.getImageFor(self)
    }

    internal func setExternalPaymentMethodImage(externalImage: UIImage?) {
        if let imageResource = externalImage {
            externalPaymentPluginImageData = UIImagePNGRepresentation(imageResource) as NSData?
        }
    }

    internal func getImageForExtenalPaymentMethod() -> UIImage? {
        if let imageDataStream = externalPaymentPluginImageData as Data? {
            return UIImage(data: imageDataStream)
        }
        return nil
    }

    // COLORS
    // First Color
    internal func getColor(bin: String?) -> UIColor {
        var settings: [PXSetting]? = nil

        if let bin = bin {
            settings = PXSetting.getSettingByBin(self.settings, bin: bin)
        }

        return MercadoPago.getColorFor(self, settings: settings)
    }
    // Font Color
    internal func getFontColor(bin: String?) -> UIColor {
        var settings: [PXSetting]? = nil

        if let bin = bin {
            settings = PXSetting.getSettingByBin(self.settings, bin: bin)
        }

        return MercadoPago.getFontColorFor(self, settings: settings)
    }
    // Edit Font Color
    internal func getEditingFontColor(bin: String?) -> UIColor {
        var settings: [PXSetting]? = nil

        if let bin = bin {
            settings = PXSetting.getSettingByBin(self.settings, bin: bin)
        }

        return MercadoPago.getEditingFontColorFor(self, settings: settings)
    }

    // MASKS
    // Label Mask
    internal func getLabelMask(bin: String?) -> String {
        var settings: [PXSetting]? = nil

        if let bin = bin {
            settings = PXSetting.getSettingByBin(self.settings, bin: bin)
        }
        return MercadoPago.getLabelMaskFor(self, settings: settings)
    }
    // Edit Text Mask
    internal func getEditTextMask(bin: String?) -> String {
        var settings: [PXSetting]? = nil

        if let bin = bin {
            settings = PXSetting.getSettingByBin(self.settings, bin: bin)
        }
        return MercadoPago.getEditTextMaskFor(self, settings: settings)
    }

    var isBolbradesco: Bool {
        return self.paymentMethodId.contains(PaymentTypeId.BOLBRADESCO.rawValue)
    }
}
