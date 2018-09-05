//
//  PXBodyComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

internal class PXBodyComponent: PXComponentizable {

    let rejectedStatusDetailsWithBody = [PXPaymentNew.StatusDetails.REJECTED_OTHER_REASON, PXPaymentNew.StatusDetails.REJECTED_BY_BANK, PXPaymentNew.StatusDetails.REJECTED_INSUFFICIENT_DATA, PXPaymentNew.StatusDetails.REJECTED_DUPLICATED_PAYMENT, PXPaymentNew.StatusDetails.REJECTED_MAX_ATTEMPTS, PXPaymentNew.StatusDetails.REJECTED_HIGH_RISK, PXPaymentNew.StatusDetails.REJECTED_CALL_FOR_AUTHORIZE, PXPaymentNew.StatusDetails.REJECTED_CARD_DISABLED, PXPaymentNew.StatusDetails.REJECTED_INSUFFICIENT_AMOUNT]

    let pendingStatusDetailsWithBody = [PXPaymentNew.StatusDetails.PENDING_CONTINGENCY, PXPaymentNew.StatusDetails.PENDING_REVIEW_MANUAL]

    var props: PXBodyProps

    init(props: PXBodyProps) {
        self.props = props
    }

    func hasInstructions() -> Bool {
        return props.instruction != nil
    }

    func getInstructionsComponent() -> PXInstructionsComponent? {
        if let instruction = props.instruction {
            let instructionsProps = PXInstructionsProps(instruction: instruction)
            let instructionsComponent = PXInstructionsComponent(props: instructionsProps)
            return instructionsComponent
        }
        return nil
    }

    private func getPaymentMethodIcon(paymentMethod: PaymentMethod) -> UIImage? {
        let defaultColor = paymentMethod.paymentTypeId == PXPaymentTypes.ACCOUNT_MONEY.rawValue && paymentMethod.paymentTypeId != PXPaymentTypes.PAYMENT_METHOD_PLUGIN.rawValue
        var paymentMethodImage: UIImage? =  ResourceManager.shared.getImageForPaymentMethod(withDescription: paymentMethod.paymentMethodId, defaultColor: defaultColor)
        // Retrieve image for payment plugin or any external payment method.
        if paymentMethod.paymentTypeId == PXPaymentTypes.PAYMENT_METHOD_PLUGIN.rawValue {
            paymentMethodImage = paymentMethod.getImageForExtenalPaymentMethod()
        }
        return paymentMethodImage
    }

    func getPaymentMethodComponent() -> PXPaymentMethodComponent {
        let pm = self.props.paymentResult.paymentData!.paymentMethod!

        let image = getPaymentMethodIcon(paymentMethod: pm)
        let currency = SiteManager.shared.getCurrency()
        var amountTitle: NSMutableAttributedString = Utils.getAmountFormated(amount: self.props.amountHelper.amountToPay, forCurrency: currency).toAttributedString()
        var subtitle: NSMutableAttributedString? = pm.paymentMethodDescription?.toAttributedString()
        if let payerCost = self.props.paymentResult.paymentData?.payerCost {
            if payerCost.installments > 1 {
                amountTitle = String(String(payerCost.installments) + "x " + Utils.getAmountFormated(amount: payerCost.installmentAmount, forCurrency: currency)).toAttributedString()
                subtitle = Utils.getAmountFormated(amount: payerCost.totalAmount, forCurrency: currency, addingParenthesis: true).toAttributedString()
            }
        }

        if self.props.amountHelper.discount != nil {
            var amount = self.props.amountHelper.preferenceAmountWithCharges

            if let payerCostTotalAmount = self.props.paymentResult.paymentData?.payerCost?.totalAmount {
                amount = payerCostTotalAmount + self.props.amountHelper.amountOff
            }

            let preferenceAmountString = Utils.getStrikethroughAmount(amount: amount, forCurrency: currency)

            if subtitle == nil {
                subtitle = preferenceAmountString
            } else {
                let discountStrikethroughFont = Utils.getFont(size: PXLayout.XXS_FONT)
                preferenceAmountString.addAttribute(NSAttributedStringKey.font, value: discountStrikethroughFont, range: NSRange.init(location: 0, length: preferenceAmountString.string.count))
                preferenceAmountString.addAttribute(NSAttributedStringKey.foregroundColor, value: ThemeManager.shared.greyColor(), range: NSRange.init(location: 0, length: preferenceAmountString.string.count))
                amountTitle.append("".getAttributedStringNewLine())
                amountTitle.append(preferenceAmountString)
            }
        }

        var pmDescription: String = ""
        let paymentMethodName = pm.name ?? ""

        let issuer = self.props.paymentResult.paymentData?.getIssuer()
        let paymentMethodIssuerName = issuer?.name ?? ""
        var descriptionDetail: NSAttributedString? = nil

        if pm.isCard {
            if let lastFourDigits = (self.props.paymentResult.paymentData?.token?.lastFourDigits) {
                pmDescription = paymentMethodName + " " + "terminada en ".localized + lastFourDigits
            }
            if paymentMethodIssuerName.lowercased() != paymentMethodName.lowercased() && !paymentMethodIssuerName.isEmpty {
                descriptionDetail = paymentMethodIssuerName.toAttributedString()
            }
        } else {
            pmDescription = paymentMethodName
        }

        var disclaimerText: String? = nil
        if let statementDescription = self.props.paymentResult.statementDescription {
            disclaimerText =  ("En tu estado de cuenta verás el cargo como %0".localized as NSString).replacingOccurrences(of: "%0", with: "\(statementDescription)")
        }

        let bodyProps = PXPaymentMethodProps(paymentMethodIcon: image, title: amountTitle, subtitle: subtitle, descriptionTitle: pmDescription.toAttributedString(), descriptionDetail: descriptionDetail, disclaimer: disclaimerText?.toAttributedString(), backgroundColor: .white, lightLabelColor: ThemeManager.shared.labelTintColor(), boldLabelColor: ThemeManager.shared.boldLabelTintColor())

        return PXPaymentMethodComponent(props: bodyProps)
    }

    func hasBodyError() -> Bool {
        return isPendingWithBody() || isRejectedWithBody()
    }

    func getBodyErrorComponent() -> PXErrorComponent {
        let status = props.paymentResult.status
        let statusDetail = props.paymentResult.statusDetail
        let paymentMethodName = props.paymentResult.paymentData?.paymentMethod?.name

        let title = getErrorTitle()
        let message = getErrorMessage(status: status, statusDetail: statusDetail, paymentMethodName: paymentMethodName)
        let secondaryTitle = getErrorSecondaryTitle(status: status, statusDetail: statusDetail)
        let action = getErrorAction(status: status, statusDetail: statusDetail, paymentMethodName: paymentMethodName)

        let errorProps = PXErrorProps(title: title.toAttributedString(), message: message?.toAttributedString(), secondaryTitle: secondaryTitle?.toAttributedString(), action: action)
        let errorComponent = PXErrorComponent(props: errorProps)
        return errorComponent
    }

    func getErrorTitle() -> String {
        return PXResourceProvider.getTitleForErrorBody()
    }

    func getErrorMessage(status: String, statusDetail: String, paymentMethodName: String?) -> String? {
        if status == PXPaymentNew.Status.PENDING || status == PXPaymentNew.Status.IN_PROCESS {
            switch statusDetail {
            case PXPaymentNew.StatusDetails.PENDING_CONTINGENCY:
                return PXResourceProvider.getDescriptionForErrorBodyForPENDING_CONTINGENCY()
            case PXPaymentNew.StatusDetails.PENDING_REVIEW_MANUAL:
                return PXResourceProvider.getDescriptionForErrorBodyForPENDING_REVIEW_MANUAL()
            default:
                return nil
            }
        } else if status == PXPaymentNew.Status.REJECTED {
            switch statusDetail {
            case PXPaymentNew.StatusDetails.REJECTED_CALL_FOR_AUTHORIZE:
                return PXResourceProvider.getDescriptionForErrorBodyForREJECTED_CALL_FOR_AUTHORIZE()
            case PXPaymentNew.StatusDetails.REJECTED_CARD_DISABLED:
                return PXResourceProvider.getDescriptionForErrorBodyForREJECTED_CARD_DISABLED(paymentMethodName)
            case PXPaymentNew.StatusDetails.REJECTED_INSUFFICIENT_AMOUNT:
                return PXResourceProvider.getDescriptionForErrorBodyForREJECTED_INSUFFICIENT_AMOUNT()
            case PXPaymentNew.StatusDetails.REJECTED_OTHER_REASON:
                return PXResourceProvider.getDescriptionForErrorBodyForREJECTED_OTHER_REASON()
            case PXPaymentNew.StatusDetails.REJECTED_BY_BANK:
                return PXResourceProvider.getDescriptionForErrorBodyForREJECTED_BY_BANK()
            case PXPaymentNew.StatusDetails.REJECTED_INSUFFICIENT_DATA:
                return PXResourceProvider.getDescriptionForErrorBodyForREJECTED_INSUFFICIENT_DATA()
            case PXPaymentNew.StatusDetails.REJECTED_DUPLICATED_PAYMENT:
                return PXResourceProvider.getDescriptionForErrorBodyForREJECTED_DUPLICATED_PAYMENT()
            case PXPaymentNew.StatusDetails.REJECTED_MAX_ATTEMPTS:
                return PXResourceProvider.getDescriptionForErrorBodyForREJECTED_MAX_ATTEMPTS()
            case PXPaymentNew.StatusDetails.REJECTED_HIGH_RISK:
                return PXResourceProvider.getDescriptionForErrorBodyForREJECTED_HIGH_RISK()
            default:
                return nil
            }
        }
        return nil
    }

    internal func getErrorAction(status: String, statusDetail: String, paymentMethodName: String?) -> PXAction? {
        if isCallForAuthorize(status: status, statusDetail: statusDetail) {
            let actionText = PXResourceProvider.getActionTextForErrorBodyForREJECTED_CALL_FOR_AUTHORIZE(paymentMethodName)
            let action = PXAction(label: actionText, action: self.props.callback)
            return action
        }
        return nil
    }

    func getErrorSecondaryTitle(status: String, statusDetail: String) -> String? {
        if isCallForAuthorize(status: status, statusDetail: statusDetail) {
            return PXResourceProvider.getSecondaryTitleForErrorBodyForREJECTED_CALL_FOR_AUTHORIZE()
        }
        return nil
    }

    func isCallForAuthorize(status: String, statusDetail: String) -> Bool {
        return status == PXPaymentNew.Status.REJECTED && statusDetail == PXPaymentNew.StatusDetails.REJECTED_CALL_FOR_AUTHORIZE
    }

    func isPendingWithBody() -> Bool {
        let hasPendingStatus = props.paymentResult.status == PXPaymentNew.Status.PENDING || props.paymentResult.status == PXPaymentNew.Status.IN_PROCESS
        return hasPendingStatus && pendingStatusDetailsWithBody.contains(props.paymentResult.statusDetail)
    }

    func isRejectedWithBody() -> Bool {
        return props.paymentResult.status == PXPaymentNew.Status.REJECTED && rejectedStatusDetailsWithBody.contains(props.paymentResult.statusDetail)
    }

    func render() -> UIView {
        return PXBodyRenderer().render(self)
    }

}

internal class PXBodyProps {
    let paymentResult: PaymentResult
    let instruction: Instruction?
    let amountHelper: PXAmountHelper
    let callback : (() -> Void)

    init(paymentResult: PaymentResult, amountHelper: PXAmountHelper, instruction: Instruction?, callback:  @escaping (() -> Void)) {
        self.paymentResult = paymentResult
        self.instruction = instruction
        self.amountHelper = amountHelper
        self.callback = callback
    }
}
