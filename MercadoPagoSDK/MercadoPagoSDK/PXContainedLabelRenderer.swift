//
//  PXContainedLabelRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 1/23/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

class PXContainedLabelRenderer: NSObject {
    
    func render(_ totalRow: PXContainedLabelComponent) -> PXTotalRowView {
        let totalRowView = PXTotalRowView()
        totalRowView.translatesAutoresizingMaskIntoConstraints = false
        
        //Total Label
        totalRowView.totalLabel = buildTotalLabel(with: totalRow.props.totalAmount)
        totalRowView.addSubview(totalRowView.totalLabel)
        PXLayout.centerVertically(view: totalRowView.totalLabel).isActive = true
        PXLayout.centerHorizontally(view: totalRowView.totalLabel).isActive = true
        PXLayout.matchWidth(ofView: totalRowView.totalLabel).isActive = true
        PXLayout.matchHeight(ofView: totalRowView.totalLabel).isActive = true
        return totalRowView
    }
    
    func buildTotalLabel(with text: NSAttributedString) -> UILabel {
        let totalLabel = UILabel()
        totalLabel.textAlignment = .center
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.attributedText = text
        totalLabel.textColor = ThemeManager.shared.getTheme().boldLabelTintColor()
        totalLabel.lineBreakMode = .byWordWrapping
        totalLabel.numberOfLines = 0
        return totalLabel
    }
}

class PXTotalRowView: PXComponentView {
    public var totalLabel: UILabel!
}


