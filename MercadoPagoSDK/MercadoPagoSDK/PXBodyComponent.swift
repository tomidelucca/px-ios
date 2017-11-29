//
//  PXBodyComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

open class PXBodyComponent: NSObject, PXComponetizable {
    var props: BodyProps

    init(props: BodyProps) {
        self.props = props
    }

    public func hasInstructions() -> Bool {
        return props.instruction != nil
    }

    public func getInstructionsComponent() -> PXInstructionsComponent? {
        let instructionsProps = InstructionsProps(instruction: props.instruction!)
        let instructionsComponent = PXInstructionsComponent(props: instructionsProps)
        return instructionsComponent
    }
    
    public func getPaymentMethodComponent() -> PXPaymentMethodBodyComponent {
        let pm = self.props.paymentResult.paymentData?.paymentMethod
        let image = MercadoPago.getImageForPaymentMethod(withDescription: (pm?._id)!)
        var amountTitle = String(self.props.amount)
        var amountDetail: String?
        if let payerCost = self.props.paymentResult.paymentData?.payerCost {
            if payerCost.installments > 1 {
                amountTitle = String(payerCost.installments) + "x " + MercadoPagoContext.getCurrency().symbol + " " + String(payerCost.installmentAmount)
                amountDetail = "(" +  String(payerCost.totalAmount) + ")"
            }
        }
        var issuerName : String?
        var pmDescription : String = ""
        if (pm?.isCreditCard)! {
            issuerName = self.props.paymentResult.paymentData?.issuer?.name
            pmDescription = (pm?.name)! + " " + "terminada en ".localized + (self.props.paymentResult.paymentData?.token?.lastFourDigits)!
        }else if (pm?.isAccountMoney)!{
            pmDescription = (pm?.name)!
        }
        
        let bodyProps = PXPaymentMethodBodyComponentProps(paymentMethodIcon: image!, amountTitle: amountTitle, amountDetail: amountDetail, paymentMethodDescription: pmDescription, paymentMethodDetail: issuerName)
        return PXPaymentMethodBodyComponent(props: bodyProps)
    }
    
    public func render() -> UIView {
        return PXBodyRenderer().render(body: self)
    }

}

open class BodyProps: NSObject {
    var paymentResult: PaymentResult
    var instruction: Instruction?
    var amount : Double
    init(paymentResult:PaymentResult, amount: Double, instruction: Instruction?) {
        self.paymentResult = paymentResult
        self.instruction = instruction
        self.amount = amount
    }
}
