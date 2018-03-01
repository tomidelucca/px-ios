//
//  PXSummaryRenderer.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 28/2/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

struct PXSummaryComponentRenderer {
    
    func render(_ summaryComponent: PXSummaryComponent) -> UIView {
    
        let summaryContainerView = PXSummaryComponentView(width: summaryComponent.props.width, summaryViewModel: summaryComponent.props.summaryViewModel, paymentData: summaryComponent.props.paymentData, totalAmount: summaryComponent.props.totalAmount)
        
        summaryContainerView.updateFrame()
        
        return summaryContainerView
    }
}
