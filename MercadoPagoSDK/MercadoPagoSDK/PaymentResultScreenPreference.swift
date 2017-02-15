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
    var approvedSubtitle = "Se le enviara un sms bla bla bla bla bla bla"
    var pendingTitle = "Estamos procesando el pago".localized
    var pendingSubtitle = ""
    var exitButttonTitle = "Continuar".localized
    var headerPendingIconName = "iconoAcreditado"
    var headerPendingIconBundle = MercadoPago.getBundle()!
    var disableSelectAnotherPaymentMethod = false
    
    func setAppovedTitle(title: String) {
        self.approvedTitle = title
    }
    
    func setAppovedSubtitle(subtitle: String) {
        self.approvedSubtitle = subtitle
    }
    
    func setPendingTitle(title: String) {
        self.pendingTitle = title
    }
    
    func setPendingSubtitle(subtitle: String) {
        self.pendingSubtitle = subtitle
    }
    
    func setExitButtonTitle(title: String) {
        self.exitButttonTitle = title
    }
    
    func setPendingHeaderIcon(name: String, bundle: Bundle) {
        self.headerPendingIconName = name
        self.headerPendingIconBundle = bundle
    }
    
    func disableChangePaymentMethodOption(){
        self.disableSelectAnotherPaymentMethod = true
    }
    
    func enableChangePaymentMethodOption(){
        self.disableSelectAnotherPaymentMethod = false
    }
    
    func getApprovedTitle() -> String {
        return approvedTitle
    }
    
    func getApprovedSubtitle() -> String {
        return approvedSubtitle
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
