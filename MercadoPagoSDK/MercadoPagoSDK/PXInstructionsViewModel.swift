//
//  PXInstructionsViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 20/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXInstructionsViewModel: NSObject {

    var paymentResult: PaymentResult?
    var instructionsInfo: InstructionsInfo?
    var preference : PaymentResultScreenPreference?

    init(paymentResult: PaymentResult? = nil, instructionsInfo: InstructionsInfo? = nil, preference : PaymentResultScreenPreference? = nil)  {
        self.paymentResult = paymentResult
        self.instructionsInfo = instructionsInfo
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
        return MercadoPago.getImage("mercadopago_cc")
        guard let result = self.paymentResult else {
            return nil
        }
        if isAccepted() {
            if result.isApproved() || result.isWaitingForPayment() {
                return MercadoPago.getImage("default_item_icon")
            }
        }
        return paymentMethodImage()
    }
    
    func paymentMethodImage() -> UIImage? {
        guard let result = self.paymentResult else {
            return nil
        }
        if (result.paymentData?.paymentMethod?.isCard)! {
            return MercadoPago.getImage("card_icon")
        } else if (result.paymentData?.paymentMethod?.isBolbradesco)! {
            return MercadoPago.getImage("boleto_icon")
        }else {
            return MercadoPago.getImage("default_payment_method_icon")
        }

        
    }
    
    func badgeImage() -> UIImage? {
        guard let result = self.paymentResult else {
            return nil
        }
        if isAccepted() {
            if result.isApproved() {
                return MercadoPago.getImage("ok_badge")
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
    
    func statusMessage() -> String? {
        guard let result = self.paymentResult else {
            return nil
        }
        if isAccepted() {
            if result.isWaitingForPayment() {
                return "¡Apúrate a pagar!".localized
            }else{
                return nil
            }
        }
        return "Algo salió mal...".localized
    }
    func message() -> String {
        guard let result = self.paymentResult else {
            return ""
        }
        if let _ = self.instructionsInfo {
            return titleForInstructions()
        }
        if isAccepted() {
            if result.isApproved() {
                return "¡Listo, se acreditó tu pago!".localized
            }else{
                return "Estamos procesando el pago".localized
            }
        }
        return titleForStatusDetail(statusDetail: result.statusDetail, paymentMethod: result.paymentData?.paymentMethod)
    }
    
    func headerComponentData() -> HeaderData {
        let data = HeaderData(title: statusMessage(), subTitle: message(), backgroundColor: primaryResultColor(), productImage: iconImageHeader(), statusImage: badgeImage())
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
    
    func titleForStatusDetail(statusDetail:String, paymentMethod: PaymentMethod?) -> String {
        guard let paymentMethod = paymentMethod else {
            return ""
        }
        let title = statusDetail + "_title"
        if !title.existsLocalized() {
            return "Uy, no pudimos procesar el pago".localized
        } else {
            if let paymentMethodName = paymentMethod.name {
                return (title.localized as NSString).replacingOccurrences(of: "%0", with: "\(paymentMethodName)")
            }else{
                return ""
            }
        }
    }
    
    func titleForInstructions() -> String {

        guard let instructionsInfo = self.instructionsInfo else {
            return ""
        }
        let currency = MercadoPagoContext.getCurrency()
        let currencySymbol = currency.getCurrencySymbolOrDefault()
        let thousandSeparator = currency.getThousandsSeparatorOrDefault()
        let decimalSeparator = currency.getDecimalSeparatorOrDefault()
        
        let arr = String(instructionsInfo.amountInfo.amount).characters.split(separator: ".").map(String.init)
        let amountStr = Utils.getAmountFormatted(arr[0], thousandSeparator: thousandSeparator, decimalSeparator: decimalSeparator)
        let centsStr = Utils.getCentsFormatted(String(instructionsInfo.amountInfo.amount), decimalSeparator: decimalSeparator)
        let amountRange = instructionsInfo.getInstruction()!.title.range(of: currencySymbol + " " + amountStr + decimalSeparator + centsStr)
        
        if amountRange != nil {
            return instructionsInfo.instructions[0].title
        } else {
            return instructionsInfo.instructions[0].title
        }
    }
    
}
