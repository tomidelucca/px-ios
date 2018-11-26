//
//  CardFormViewController+Tracking.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 26/11/2018.
//

import Foundation
// MARK: Tracking
extension CardFormViewController {
    func trackStatus() {
        guard let cardType = self.viewModel.getPaymentMethodTypeId() else {
            return
        }
        var properties: [String: Any] = [:]
        properties["payment_method_id"] = viewModel.guessedPMS?.first?.getPaymentIdForTracking()
        let screenPath = getScreenPath(cardType: cardType)
        MPXTracker.sharedInstance.trackScreen(screenName: screenPath, properties: properties)
    }
    func trackError(errorMessage: String) {
        guard let cardType = self.viewModel.getPaymentMethodTypeId() else {
            return
        }
        var properties: [String: Any] = [:]
        properties["path"] = getScreenPath(cardType: cardType)
        properties["style"] = "custom_component"
        properties["id"] = getIdError()
        properties["message"] = errorMessage
        properties["attributable_to"] = "user"
        var extraDic: [String: Any] = [:]
        extraDic["payment_method_type"] = viewModel.guessedPMS?.first?.getPaymentTypeForTracking()
        extraDic["payment_method_id"] = viewModel.guessedPMS?.first?.getPaymentIdForTracking()
        if viewModel.guessedPMS == nil || viewModel.guessedPMS?.isEmpty ?? false {
            extraDic["user_input"] = textBox.text
        }
        properties["extra_info"] = extraDic
        MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.getErrorPath(), properties: properties)
    }
    func getScreenPath(cardType: String) -> String {
        var screenPath = ""
        if editingLabel === cardNumberLabel {
            screenPath = TrackingPaths.Screens.CardForm.getCardNumberPath(paymentTypeId: cardType)
        } else if editingLabel === nameLabel {
            screenPath = TrackingPaths.Screens.CardForm.getCardNamePath(paymentTypeId: cardType)
        } else if editingLabel === expirationDateLabel {
            screenPath = TrackingPaths.Screens.CardForm.getExpirationDatePath(paymentTypeId: cardType)
        } else if editingLabel === cvvLabel {
            screenPath = TrackingPaths.Screens.CardForm.getCvvPath(paymentTypeId: cardType)
        }
        return screenPath
    }
    func getIdError() -> String {
        var idError = ""
        if editingLabel === cardNumberLabel {
            if viewModel.guessedPMS == nil || viewModel.guessedPMS?.isEmpty ?? false {
                idError = "invalid_bin"
            } else {
                idError = "invalid_cc_number"
            }
        } else if editingLabel === nameLabel {
            idError = "null_cc_name"
        } else if editingLabel === expirationDateLabel {
            idError = "invalid_expiration_date"
        } else if editingLabel === cvvLabel {
            idError = "invalid_cvv"
        }
        return idError
    }
}
