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
        // TODO: Check defaults logic for compact or full summary with UX.
        guard let payerCost = summaryComponent.props.paymentData.getPayerCost(), payerCost.installments > 1 else { return buildCompactSummary(props: summaryComponent.props) }
        return buildFullSummary(props: summaryComponent.props)
    }
}

extension PXSummaryComponentRenderer {
    
    fileprivate func buildFullSummary(props:PXSummaryComponentProps) -> UIView {
        let fullSummaryView = PXSummaryFullComponentView(width: props.width, summaryViewModel: props.summaryViewModel, paymentData: props.paymentData, totalAmount: props.totalAmount, backgroundColor: props.backgroundColor)
        PXLayout.setHeight(owner: fullSummaryView, height: fullSummaryView.requiredHeight).isActive = true
        return fullSummaryView
    }
    
    fileprivate func buildCompactSummary(props:PXSummaryComponentProps) -> UIView {
        
        let compactView = PXSummaryCompactComponentView()
        let BASELINE_OFFSET: Int = 10
        let DEFAULT_TITLE = "Default title" //TODO: Check with UX default scenario/title.
        
        compactView.backgroundColor = props.backgroundColor
        compactView.translatesAutoresizingMaskIntoConstraints = false
        
        let amountAttributeText = Utils.getAttributedAmount(props.totalAmount, currency: MercadoPagoContext.getCurrency(), color : props.textColor, fontSize: PXLayout.XXXL_FONT, baselineOffset:BASELINE_OFFSET)
        
        var customTitle = DEFAULT_TITLE
        if let cTitle = props.customTitle {
            customTitle = cTitle
        }
        
        let customTitleAttributeText = NSAttributedString(string: customTitle, attributes: [NSFontAttributeName: Utils.getFont(size: PXLayout.XS_FONT)])

        let viewHeight = compactView.buildView(amountAttributeText: amountAttributeText, bottomCustomTitle: customTitleAttributeText, textColor: props.textColor, backgroundColor: props.backgroundColor)
        
        PXLayout.setHeight(owner: compactView, height: viewHeight).isActive = true
        
        return compactView
    }
}
