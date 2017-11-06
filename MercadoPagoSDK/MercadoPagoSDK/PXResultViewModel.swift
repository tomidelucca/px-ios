  //
//  PXResultViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 20/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXResultViewModel: NSObject {

    var paymentResult: PaymentResult?
    var instructionsInfo: InstructionsInfo?
    var preference : PaymentResultScreenPreference

    init(paymentResult: PaymentResult? = nil, instructionsInfo: InstructionsInfo? = nil, preference : PaymentResultScreenPreference? = nil)  {
        self.paymentResult = paymentResult
        self.instructionsInfo = instructionsInfo
        if let pref =  preference {
            self.preference = pref
        }else {
            self.preference = PaymentResultScreenPreference()
        }
    }
    
    func primaryResultColor() -> UIColor {
        if isAccepted() {
            return .pxGreenMp
        }
        if isError() {
            return .pxRedMp
        }
        if isWarning() {
            return .pxOrangeMp
        }
        return .white
    }
    
    func iconImageHeader() -> UIImage? {
        guard let result = self.paymentResult else {
            return nil
        }
        if isAccepted() {
            if result.isApproved() {
                return preference.getHeaderApprovedIcon()
            }else if result.isWaitingForPayment(){
                return preference.getHeaderPendingIcon()
            } else{
                return preference.getHeaderImageFor(result.paymentData?.paymentMethod)
            }
        }else {
            return preference.getHeaderRejectedIcon(paymentResult?.paymentData?.paymentMethod)
        }
        
    }
    
    func badgeImage() -> UIImage? {
        guard let result = self.paymentResult else {
            return nil
        }
        if !preference._showBadgeImage {
            return nil
        }
        if isAccepted() {
            if result.isApproved() {
                return preference.getApprovedBadgeImage()
            }else{
                return MercadoPago.getImage("pending_badge")
            }
        }
        if isWarning() {
            return MercadoPago.getImage("need_action_badge")
        }
        if  isError() {
            return MercadoPago.getImage("error_badge")
        }
        return nil
    }
    
    func labelTextHeader() -> NSAttributedString? {
        guard let result = self.paymentResult else {
            return nil
        }
        if isAccepted() {
            if result.isWaitingForPayment() {
                return "¡Apúrate a pagar!".localized.toAttributedString()
            }else{
                var labelText : String? 
                if result.isApproved() {
                    labelText = preference.getApprovedLabelText()
                }else{
                    labelText = preference.getPendingLabelText()
                }
                guard let text = labelText else {
                    return nil
                }
                return text.toAttributedString()
            }
        }
        if !preference._showLabelText {
            return nil
        }else{
            return "Algo salió mal...".localized.toAttributedString()
        }
        
    }
    func titleHeader() -> NSAttributedString {
        guard let result = self.paymentResult else {
            return "".toAttributedString()
        }
        if let _ = self.instructionsInfo {
            return titleForInstructions().toAttributedString()
        }
        if isAccepted() {
            if result.isApproved() {
                return preference.getApprovedTitle().toAttributedString()
            }else{
                return "Estamos procesando el pago".localized.toAttributedString()
            }
        }
        if let title = preference.getRejectedTitle() {
            return title.toAttributedString()
        }
        return titleForStatusDetail(statusDetail: result.statusDetail, paymentMethod: result.paymentData?.paymentMethod)
    }
    
    func headerComponentData() -> HeaderData {
        let data = HeaderData(labelText: labelTextHeader(), title: titleHeader(), backgroundColor: primaryResultColor(), productImage: iconImageHeader(), statusImage: badgeImage())
        return data
    }
    
    func isAccepted() -> Bool {
        guard let result = self.paymentResult else {
            return false
        }
        if result.isApproved() || result.isInProcess() || result.isPending() {
            return true
        }else{
            return false
        }
    }
    
    func isWarning() -> Bool {
        guard let result = self.paymentResult else {
            return false
        }
        if !result.isRejected() {
            return false
        }
        if result.statusDetail == RejectedStatusDetail.INVALID_ESC || result.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || result.statusDetail == RejectedStatusDetail.BAD_FILLED_CARD_NUMBER || result.statusDetail == RejectedStatusDetail.CARD_DISABLE || result.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT || result.statusDetail == RejectedStatusDetail.BAD_FILLED_DATE || result.statusDetail == RejectedStatusDetail.BAD_FILLED_SECURITY_CODE || result.statusDetail == RejectedStatusDetail.BAD_FILLED_OTHER {
            return true
        }
        
        return false
    }
    func isError() -> Bool {
        guard let result = self.paymentResult else {
            return true
        }
        if !result.isRejected() {
            return false
        }
        return !isWarning()
    }
    
    func titleForStatusDetail(statusDetail:String, paymentMethod: PaymentMethod?) -> NSAttributedString {
        guard let paymentMethod = paymentMethod else {
            return "".toAttributedString()
        }
        if statusDetail == RejectedStatusDetail.CALL_FOR_AUTH {
            if let paymentMethodName = paymentMethod.name {
                let currency = MercadoPagoContext.getCurrency()
                let currencySymbol = currency.getCurrencySymbolOrDefault()
                let thousandSeparator = currency.getThousandsSeparatorOrDefault()
                let decimalSeparator = currency.getDecimalSeparatorOrDefault()
                let amountStr = Utils.getAttributedAmount(self.paymentResult!.paymentData!.payerCost!.totalAmount, thousandSeparator: thousandSeparator, decimalSeparator: decimalSeparator, currencySymbol: currencySymbol, color: .green)
                    //self.amountFormatter(amount: String(format:"%.2f",self.paymentResult!.paymentData!.payerCost!.totalAmount ))
                let string : NSMutableAttributedString = "Debes autorizar ante %1$s el pago de ".localized.replacingOccurrences(of: "%1$s", with: "\(paymentMethodName)").toAttributedString() as! NSMutableAttributedString
                var result : NSMutableAttributedString = string
                result.append(amountStr)
                result.append(" a MercadoPago".localized.toAttributedString())
                return result
            }else{
                return "".toAttributedString()
            }
            
        }
        let title = statusDetail + "_title"
        if !title.existsLocalized() {
            return "Uy, no pudimos procesar el pago".localized.toAttributedString()
        } else {
            if let paymentMethodName = paymentMethod.name {
                return (title.localized as NSString).replacingOccurrences(of: "%0", with: "\(paymentMethodName)").toAttributedString()
            }else{
                return "".toAttributedString()
            }
        }
    }
    
    func titleForInstructions() -> String {

        guard let instructionsInfo = self.instructionsInfo else {
            return ""
        }
        return instructionsInfo.instructions[0].title

    }
    
    
    func amountFormatter(amount:String) -> String {
        let currency = MercadoPagoContext.getCurrency()
        let currencySymbol = currency.getCurrencySymbolOrDefault()
        let thousandSeparator = currency.getThousandsSeparatorOrDefault()
        let decimalSeparator = currency.getDecimalSeparatorOrDefault()
        let arr = String(amount).characters.split(separator: ".").map(String.init)
        let amountStr = Utils.getAmountFormatted(arr[0], thousandSeparator: thousandSeparator, decimalSeparator: decimalSeparator)
        let centsStr = Utils.getCentsFormatted(String(amount), decimalSeparator: decimalSeparator)
        return currencySymbol + amountStr + decimalSeparator + centsStr
    }
}

  
  extension String {
    public func toAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: nil)
    }
  }
