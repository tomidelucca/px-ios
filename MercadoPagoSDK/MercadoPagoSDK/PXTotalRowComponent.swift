//
//  PXTotalRowComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 1/23/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

open class PXTotalRowComponent: PXComponentizable {
    
    public func render() -> UIView {
        return PXTotalRowRenderer().render(self)
    }
    
    var props: PXTotalRowProps
    
    init(props: PXTotalRowProps) {
        self.props = props
    }
}

open class PXTotalRowProps: NSObject {
    var totalAmount: NSAttributedString
    init(totalAmount: NSAttributedString) {
        self.totalAmount = totalAmount
    }
}


