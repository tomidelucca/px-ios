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
        return PXResourceProvider.getTitleForErrorBody(status: props.status, statusDetail: props.statusDetail)
    }
    
    public func getDescription() -> String {
        return PXResourceProvider.getDescriptionForErrorBody(status: props.status, statusDetail: props.statusDetail)
    }
    
    public func getActionText() -> String {
        return PXResourceProvider.getActionTextForErrorBody(props.paymentMethodName)
    }
    
    public func getSecondaryTitleForCallForAuth() -> String {
        return PXResourceProvider.getSecondaryTitleForErrorBody(status: props.status, statusDetail: props.statusDetail)
    }
    
    public func isCallForAuthorize() -> Bool {
        return props.status.elementsEqual(PXPayment.Status.REJECTED) && props.statusDetail.elementsEqual(PXPayment.StatusDetails.REJECTED_CALL_FOR_AUTHORIZE)
    }
    
    public func hasActionForCallForAuth() -> Bool {
        return isCallForAuthorize() && !String.isNullOrEmpty(props.paymentMethodName)
    }
    
    public func recoverPayment() {
        self.props.action()
    }
}

class PXErrorProps: NSObject {
    var status: String
    var statusDetail: String
    var paymentMethodName: String?
    var action : (() -> Void)
    
    init(status: String, statusDetail: String, paymentMethodName: String?, action:  @escaping (() -> Void)) {
        self.status = status
        self.statusDetail = statusDetail
        self.paymentMethodName = paymentMethodName
        self.action = action
    }
}
