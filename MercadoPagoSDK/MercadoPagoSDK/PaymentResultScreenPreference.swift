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
    var approvedSubtitle = ""
    var pendingTitle = "Estamos procesando el pago".localized
    var pendingSubtitle = ""
    var contentTitle = "¿Qué puedo hacer?".localized
    var contentText = ""
    var exitButttonTitle = "Continuar".localized
    var headerPendingIconName = "iconoAcreditado"
    var headerPendingIconBundle = MercadoPago.getBundle()!
    var hideChangePaymentMethodCell = false
    var hideChangePaymentMethodButton = false
    var hidePendingContentText = false
    var hideAmount = false
    var hidePaymentId = false
    var hidePaymentMethod = false
    
    internal static var pendingAdditionalInfoCells = [MPCustomCell]()
    internal static var approvedAdditionalInfoCells = [MPCustomCell]()
    
    open func setAppovedTitle(title: String) {
        self.approvedTitle = title
    }
    
    open func setAppovedSubtitle(subtitle: String) {
        self.approvedSubtitle = subtitle
    }
    
    open func setPendingTitle(title: String) {
        self.pendingTitle = title
    }
    
    open func setPendingSubtitle(subtitle: String) {
        self.pendingSubtitle = subtitle
    }
    
    open func setExitButtonTitle(title: String) {
        self.exitButttonTitle = title
    }
    
    open func setPendingHeaderIcon(name: String, bundle: Bundle) {
        self.headerPendingIconName = name
        self.headerPendingIconBundle = bundle
    }
    
    open func disableChangePaymentMethodOptionCell(){
        self.hideChangePaymentMethodCell = true
    }
    
    open func disableChangePaymentMethodOptionButton(){
        self.hideChangePaymentMethodButton = true
    }
    
    open func disablePendingContentText() {
        self.hidePendingContentText = true
    }
    
    open func disableApprovedAmount() {
        self.hideAmount = true
    }
    
    open func disableApprovedReceipt() {
        self.hidePaymentId = true
    }
    
    open func disableApprovedPaymentMethodInfo() {
        self.hidePaymentMethod = true
    }
    
    open func enableAmount() {
        self.hideAmount = false
    }
    
    open func enableApprovedReceipt(){
        self.hidePaymentId = true
    }
    
    open func enableChangePaymentMethodOptionButton(){
        self.hideChangePaymentMethodButton = false
    }
    
    open func enableChangePaymentMethodOptionCell(){
        self.hideChangePaymentMethodCell = false
    }
    
    open func enablePaymentContentText() {
        self.hidePendingContentText = false
    }
    
    open func enableApprovedPaymentMethodInfo() {
        self.hidePaymentMethod = false
    }
    
    open static func addCustomPendingCell(customCell : MPCustomCell) {
        PaymentResultScreenPreference.pendingAdditionalInfoCells.append(customCell)
    }
    
    open static func addCustomApprovedCell(customCell : MPCustomCell) {
        PaymentResultScreenPreference.approvedAdditionalInfoCells.append(customCell)
    }
    
    open static func clear() {
        PaymentResultScreenPreference.approvedAdditionalInfoCells = [MPCustomCell]()
        PaymentResultScreenPreference.pendingAdditionalInfoCells = [MPCustomCell]()
    }
    
    open func setPendingContentText(text: String){
        self.contentText = text
    }
    
    open func setPendingContentTitle(title: String){
        self.contentTitle = title
    }
    
    open func getApprovedTitle() -> String {
        return approvedTitle
    }
    
    open func getApprovedSubtitle() -> String {
        return approvedSubtitle
    }
    
    open func getPendingTitle() -> String {
        return pendingTitle
    }
    
    open func getPendingSubtitle() -> String {
        return pendingSubtitle
    }
    
    open func getExitButtonTitle() -> String {
        return exitButttonTitle
    }
    
    open func getHeaderPendingIcon() -> UIImage? {
        return MercadoPago.getImage(headerPendingIconName, bundle: headerPendingIconBundle)
    }
    
    open func isSelectAnotherPaymentMethodDisableCell() -> Bool {
        return hideChangePaymentMethodCell
    }
    
    open func isSelectAnotherPaymentMethodDisableButton() -> Bool {
        return hideChangePaymentMethodButton
    }
    
    open func isPendingContentTextDisable() -> Bool {
        return hidePendingContentText
    }
    
    open func isPaymentMethodDisable() -> Bool {
        return hidePaymentMethod
    }
    
    open func isAmountDisable() -> Bool {
        return hideAmount
    }
    
    open func isPaymentIdDisable() -> Bool {
        return hidePaymentId
    }
    
    open func getPendingContetTitle() -> String {
        return contentTitle
    }
    
    open func getPendingContentText() -> String {
        return contentText
    }
}
