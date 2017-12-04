//
//  PXBodyComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

open class PXBodyComponent: NSObject, PXComponetizable {
    var props: PXBodyProps

    init(props: PXBodyProps) {
        self.props = props
    }

    public func hasInstructions() -> Bool {
        return props.instruction != nil
    }

    public func getInstructionsComponent() -> PXInstructionsComponent? {
        if let instruction = props.instruction {
            let instructionsProps = PXInstructionsProps(instruction: instruction)
            let instructionsComponent = PXInstructionsComponent(props: instructionsProps)
            return instructionsComponent
        }
        return nil
    }

    public func getPaymentMethodComponent() -> PXPaymentMethodComponent {
        let pm = self.props.paymentResult.paymentData?.paymentMethod
        let image = MercadoPago.getImageForPaymentMethod(withDescription: (pm?._id)!)
        let currency = MercadoPagoContext.getCurrency()
        var amountTitle = Utils.getAmountFormated(amount: self.props.amount, forCurrency: currency)
        var amountDetail: String?
        if let payerCost = self.props.paymentResult.paymentData?.payerCost {
            if payerCost.installments > 1 {
                amountTitle = String(payerCost.installments) + "x " + Utils.getAmountFormated(amount: payerCost.installmentAmount, forCurrency: currency)
                amountDetail = Utils.getAmountFormated(amount: payerCost.totalAmount, forCurrency: currency, addingParenthesis: true)
            }
        }
        var issuerName: String?
        var pmDescription: String = ""
        if (pm?.isCreditCard)! {
            issuerName = self.props.paymentResult.paymentData?.issuer?.name
            if let lastFourDigits = (self.props.paymentResult.paymentData?.token?.lastFourDigits) {
                pmDescription = (pm?.name)! + " " + "terminada en ".localized + lastFourDigits
            }
        }else if (pm?.isAccountMoney)! {
            pmDescription = (pm?.name)!
        }
        var disclaimerText: String? = nil
        if let statementDescription = self.props.paymentResult.statementDescription {
            disclaimerText =  ("En tu estado de cuenta verás el cargo como %0".localized as NSString).replacingOccurrences(of: "%0", with: "\(statementDescription)")
        }

        let bodyProps = PXPaymentMethodProps(paymentMethodIcon: image!, amountTitle: amountTitle, amountDetail: amountDetail, paymentMethodDescription: pmDescription, paymentMethodDetail: issuerName, disclaimer: disclaimerText)

        return PXPaymentMethodComponent(props: bodyProps)
    }
    
    public func getBodyErrorComponent() -> PXErrorComponent {
        let status = props.paymentResult.status
        let statusDetail = props.paymentResult.statusDetail
        let paymentMethodName = props.paymentResult.paymentData?.paymentMethod?.name
        let errorProps = PXErrorProps(status: status, statusDetail: statusDetail, paymentMethodName: paymentMethodName!)
        let errorComponent = PXErrorComponent(props: errorProps)
        return errorComponent
    }
    
    public func isPendingWithBody() -> Bool {
//        return (props.paymentResult.status.elementsEqual(PaymentStatus.PENDING) || props.paymentResult.status.elementsEqual(PaymentStatus.IN_PROCESS)) && (props.paymentResult.statusDetail.elementsEqual())
        return true
    }
    
    public func isRejectedWithBody() -> Bool {
        return true
    }
    
//    private boolean isPendingWithBody() {
//    return (props.status.equals(Payment.StatusCodes.STATUS_PENDING) || props.status.equals(Payment.StatusCodes.STATUS_IN_PROCESS)) &&
//    (props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_PENDING_CONTINGENCY) ||
//    props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_PENDING_REVIEW_MANUAL));
//    }
    
//    private boolean isRejectedWithBody() {
//    return (props.status.equals(Payment.StatusCodes.STATUS_REJECTED) &&
//    (props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_CC_REJECTED_OTHER_REASON) ||
//    props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_REJECTED_REJECTED_BY_BANK) ||
//    props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_REJECTED_REJECTED_INSUFFICIENT_DATA) ||
//    props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_CC_REJECTED_DUPLICATED_PAYMENT) ||
//    props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_CC_REJECTED_MAX_ATTEMPTS) ||
//    props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_REJECTED_HIGH_RISK) ||
//    props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_CC_REJECTED_CALL_FOR_AUTHORIZE) ||
//    props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_CC_REJECTED_CARD_DISABLED) ||
//    props.statusDetail.equals(Payment.StatusCodes.STATUS_DETAIL_CC_REJECTED_INSUFFICIENT_AMOUNT)));
//    }

    public func render() -> UIView {
        return PXBodyRenderer().render(self)
    }

}

open class PXBodyProps: NSObject {
    var paymentResult: PaymentResult
    var instruction: Instruction?
    var amount: Double
    init(paymentResult: PaymentResult, amount: Double, instruction: Instruction?) {
        self.paymentResult = paymentResult
        self.instruction = instruction
        self.amount = amount
    }
}
