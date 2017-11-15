//
//  PXResultViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 20/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public class PXResultViewModel: NSObject {

    var paymentResult: PaymentResult?
    var instructionsInfo: InstructionsInfo?
    var preference: PaymentResultScreenPreference

    init(paymentResult: PaymentResult? = nil, instructionsInfo: InstructionsInfo? = nil, paymentResultScreenPreference: PaymentResultScreenPreference = PaymentResultScreenPreference()) {
        self.paymentResult = paymentResult
        self.instructionsInfo = instructionsInfo
        self.preference =  paymentResultScreenPreference
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
            }else if result.isWaitingForPayment() {
                return preference.getHeaderPendingIcon()
            } else {
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
            }else {
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
                return "¡Apúrate a pagar!".localized.toAttributedString(attributes:[NSFontAttributeName: Utils.getFont(size: HeaderRenderer.LABEL_FONT_SIZE)])
            }else {
                var labelText: String?
                if result.isApproved() {
                    labelText = preference.getApprovedLabelText()
                }else {
                    labelText = preference.getPendingLabelText()
                }
                guard let text = labelText else {
                    return nil
                }
                return text.toAttributedString(attributes:[NSFontAttributeName: Utils.getFont(size: HeaderRenderer.LABEL_FONT_SIZE)])
            }
        }
        if !preference._showLabelText {
            return nil
        }else {
            return NSMutableAttributedString(string: "Algo salió mal...".localized, attributes: [NSFontAttributeName: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE)])
        }

    }
    func titleHeader() -> NSAttributedString {
        guard let result = self.paymentResult else {
            return "".toAttributedString()
        }
        if let _ = self.instructionsInfo {
            return titleForInstructions()
        }
        if isAccepted() {
            if result.isApproved() {
                return NSMutableAttributedString(string: preference.getApprovedTitle(), attributes: [NSFontAttributeName: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE)])
            }else {
                return NSMutableAttributedString(string: "Estamos procesando el pago".localized, attributes: [NSFontAttributeName: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE)])
            }
        }
        if preference.rejectedTitleSetted {
            return NSMutableAttributedString(string: preference.getRejectedTitle(), attributes: [NSFontAttributeName: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE)])
        }
        return titleForStatusDetail(statusDetail: result.statusDetail, paymentMethod: result.paymentData?.paymentMethod)
    }

    func headerComponentData() -> HeaderProps {
        let data = HeaderProps(labelText: labelTextHeader(), title: titleHeader(), backgroundColor: primaryResultColor(), productImage: iconImageHeader(), statusImage: badgeImage())
        return data
    }

    func isAccepted() -> Bool {
        guard let result = self.paymentResult else {
            return false
        }
        if result.isApproved() || result.isInProcess() || result.isPending() {
            return true
        }else {
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

    func titleForStatusDetail(statusDetail: String, paymentMethod: PaymentMethod?) -> NSAttributedString {
        guard let paymentMethod = paymentMethod else {
            return "".toAttributedString()
        }
        if statusDetail == RejectedStatusDetail.CALL_FOR_AUTH {
            if let paymentMethodName = paymentMethod.name {
                let currency = MercadoPagoContext.getCurrency()
                let currencySymbol = currency.getCurrencySymbolOrDefault()
                let thousandSeparator = currency.getThousandsSeparatorOrDefault()
                let decimalSeparator = currency.getDecimalSeparatorOrDefault()
                let amountStr = Utils.getAttributedAmount(self.paymentResult!.paymentData!.payerCost!.totalAmount, thousandSeparator: thousandSeparator, decimalSeparator: decimalSeparator, currencySymbol: currencySymbol, color: UIColor.px_white(), fontSize:HeaderRenderer.TITLE_FONT_SIZE, centsFontSize:HeaderRenderer.TITLE_FONT_SIZE/2)
                let string = "Debes autorizar ante %1$s el pago de ".localized.replacingOccurrences(of: "%1$s", with: "\(paymentMethodName)")
                var result: NSMutableAttributedString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE)])
                result.append(amountStr)
                result.append(NSMutableAttributedString(string: " a MercadoPago".localized, attributes: [NSFontAttributeName: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE)]))
                return result
            }else {
                return "".toAttributedString()
            }

        }
        let title = statusDetail + "_title"
        if !title.existsLocalized() {
            return NSMutableAttributedString(string: "Uy, no pudimos procesar el pago".localized, attributes: [NSFontAttributeName: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE)])
        } else {
            if let paymentMethodName = paymentMethod.name {
                return (title.localized as NSString).replacingOccurrences(of: "%0", with: "\(paymentMethodName)").toAttributedString()
            }else {
                return "".toAttributedString()
            }
        }
    }

    func titleForInstructions() -> NSMutableAttributedString {
        guard let instructionsInfo = self.instructionsInfo else {
            return "".toAttributedString()
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
            let attributedTitle = NSMutableAttributedString(string: (instructionsInfo.instructions[0].title.substring(to: (amountRange?.lowerBound)!)), attributes: [NSFontAttributeName: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE)])
            let attributedAmount = Utils.getAttributedAmount(instructionsInfo.amountInfo.amount, thousandSeparator: thousandSeparator, decimalSeparator: decimalSeparator, currencySymbol: currencySymbol, color: UIColor.px_white(), fontSize:HeaderRenderer.TITLE_FONT_SIZE, centsFontSize:HeaderRenderer.TITLE_FONT_SIZE/2, smallSymbol: true)
            attributedTitle.append(attributedAmount)
            let endingTitle = NSAttributedString(string: (instructionsInfo.instructions[0].title.substring(from: (amountRange?.upperBound)!)), attributes: [NSFontAttributeName: Utils.getFont(size: HeaderRenderer.TITLE_FONT_SIZE)])
            attributedTitle.append(endingTitle)

            return attributedTitle
        } else {
            let attributedTitle = NSMutableAttributedString(string: (instructionsInfo.instructions[0].title), attributes: [NSFontAttributeName: Utils.getFont(size: 26)])
            return attributedTitle
        }
    }

}

 
