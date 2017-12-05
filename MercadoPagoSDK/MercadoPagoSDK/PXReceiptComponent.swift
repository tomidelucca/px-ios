//
//  PXReceiptComponent.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 4/12/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXReceiptComponent: PXComponetizable {
    var props : PXRecieptProps

    init(props: PXRecieptProps) {
        self.props = props
    }
    func render() -> UIView {
        return PXReceiptComponentRenderer().render(self)
    }
}
open class PXRecieptProps: NSObject {
    var dateLabelString : String?
    var recieptDescriptionString : String?
    init(dateLabelString : String? = nil, recieptDescriptionString: String? = nil) {
        self.dateLabelString = dateLabelString
        self.recieptDescriptionString = recieptDescriptionString
    }
}
