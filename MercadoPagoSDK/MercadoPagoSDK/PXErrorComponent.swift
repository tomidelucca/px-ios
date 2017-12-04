//
//  PXErrorComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/4/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoServices

public class PXErrorComponent: NSObject, PXComponetizable {
    var props: PXErrorProps
    var TITLE_LABEL_FONT_SIZE: CGFloat = 10
    
    init(props: PXErrorProps) {
        self.props = props
    }
    public func render() -> UIView {
        return PXErrorRenderer().render(component: self)
    }
    
    public func getTitle() -> String {
        return "¿Que puedo hacer?"
    }
    
    public func getDescription() -> String {
        return "El teléfono está al dorso de tu tarjeta."
    }
    
    public func getActionText() -> String {
        return "Ya hablé con Visa y me autorizó"
    }
    
    public func getSecondaryTitleForCallForAuth() -> String {
        return "¿No pudiste autorizarlo?"
    }
    
    public func isCallForAuthorize() -> Bool {
        return props.status.elementsEqual(PXPayment.Status.REJECTED) && props.statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_CALL_FOR_AUTHORIZE)
    }
    
    public func hasActionForCallForAuth() -> Bool {
        return isCallForAuthorize() && !String.isNullOrEmpty(props.paymentMethodName)
    }
    
    public func recoverPayment() {
        
    }
}

class PXErrorProps: NSObject {
    var status: String
    var statusDetail: String
    var paymentMethodName: String?
    
    init(status: String, statusDetail: String, paymentMethodName: String?) {
        self.status = status
        self.statusDetail = statusDetail
        self.paymentMethodName = paymentMethodName
    }
}

