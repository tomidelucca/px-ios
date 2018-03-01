//
//  PXSummaryComponent.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 28/2/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

class PXSummaryComponent: PXComponentizable {
    
    var props: PXSummaryComponentProps
    
    public func render() -> UIView {
        return PXSummaryComponentRenderer().render(self)
    }
    
    init(props: PXSummaryComponentProps) {
        self.props = props
    }
}
