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
        var amountTitle = MercadoPagoContext.getCurrency().symbol + " " + String(format:"%.02f",self.props.amount)
        var amountDetail: String?
        if let payerCost = self.props.paymentResult.paymentData?.payerCost {
            if payerCost.installments > 1 {
                amountTitle = String(payerCost.installments) + "x " + MercadoPagoContext.getCurrency().symbol + " " + String(payerCost.installmentAmount)
                amountDetail = "(" +  String(payerCost.totalAmount) + ")"
            }
        }
        var issuerName: String?
        var pmDescription: String = ""
        if (pm?.isCreditCard)! {
            issuerName = self.props.paymentResult.paymentData?.issuer?.name
            pmDescription = (pm?.name)! + " " + "terminada en ".localized + (self.props.paymentResult.paymentData?.token?.lastFourDigits)!
        }else if (pm?.isAccountMoney)! {
            pmDescription = (pm?.name)!
        }
        var disclaimerText : String? = nil
        if let statementDescription = self.props.paymentResult.statementDescription {
            disclaimerText =  ("En tu estado de cuenta verás el cargo como %0".localized as NSString).replacingOccurrences(of: "%0", with: "\(statementDescription)")
        }
       
        let bodyProps = PXPaymentMethodComponentProps(paymentMethodIcon: image!, amountTitle: amountTitle, amountDetail: amountDetail, paymentMethodDescription: pmDescription, paymentMethodDetail: issuerName, disclaimer: disclaimerText)

        return PXPaymentMethodComponent(props: bodyProps)
    }

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
