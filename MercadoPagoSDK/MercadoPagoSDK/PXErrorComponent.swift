//
//  PXErrorComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/4/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public class PXErrorComponent: NSObject, PXComponetizable {
    var props: PXErrorProps
    var TITLE_LABEL_FONT_SIZE: CGFloat = 10
    
    init(props: PXErrorProps) {
        self.props = props
    }
    public func render() -> UIView {
        return PXErrorRenderer().render(component: self)
    }
    
    public func getTitle() -> NSAttributedString {
        let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_LABEL_FONT_SIZE) ]
        let attributedString = NSAttributedString(string: "infoTitle", attributes: attributes)
        return attributedString
    }
    
    public func getDescription() -> NSAttributedString {
        let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_LABEL_FONT_SIZE) ]
        let attributedString = NSAttributedString(string: "infoTitle", attributes: attributes)
        return attributedString
    }
    
    public func getActionText() -> NSAttributedString {
        let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_LABEL_FONT_SIZE) ]
        let attributedString = NSAttributedString(string: "infoTitle", attributes: attributes)
        return attributedString
    }
    
    public func getSecondaryTitleForCallForAuth() -> NSAttributedString {
        let attributes = [ NSFontAttributeName: Utils.getFont(size: TITLE_LABEL_FONT_SIZE) ]
        let attributedString = NSAttributedString(string: "infoTitle", attributes: attributes)
        return attributedString
    }
    
    public func isCallForAuthorize() -> Bool {
        return true
    }
    
    public func hasActionForCallForAuth() -> Bool {
        return true
    }
    
    public func recoverPayment() -> Bool {
        return true
    }
}

class PXErrorProps: NSObject {
    var status: String
    var statusDetail: String
    var paymentMethodName: String
    
    init(status: String, statusDetail: String, paymentMethodName: String) {
        self.status = status
        self.statusDetail = statusDetail
        self.paymentMethodName = paymentMethodName
    }
}

