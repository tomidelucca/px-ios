//
//  PaymentResultScreenPreference.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

open class PaymentResultScreenPreference: NSObject {
    
    var approvedTitle = "¡Listo, se acreditó tu pago!".localized
    var approvedSubTitle = "H"
    var pendingTitle = "Estamos procesando el pago".localized
    var pendingSubtitle = "H"
    var exitButttonTitle = "Continuar".localized
    var headerPendingIconName = "iconoAcreditado"
    var headerPendingIconBundle = MercadoPago.getBundle()!
    var disableSelectAnotherPaymentMethod = false
    
    func getApprovedTitle() -> String {
        return approvedTitle
    }
    
    func getApprovedSubtitle() -> String {
        return approvedSubTitle
    }
    
    func getPendingTitle() -> String {
        return pendingTitle
    }
    
    func getPendingSubtitle() -> String {
        return pendingSubtitle
    }
    
    func getExitButtonTitle() -> String {
        return exitButttonTitle
    }
    
    func getHeaderPendingIcon() -> UIImage? {
        return MercadoPago.getImage(headerPendingIconName, bundle: headerPendingIconBundle)
    }
    
    func isSelectAnotherPaymentMethodDisable() -> Bool {
        return disableSelectAnotherPaymentMethod
    }
}
