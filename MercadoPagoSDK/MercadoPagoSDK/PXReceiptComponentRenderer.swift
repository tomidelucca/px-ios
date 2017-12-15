//
//  PXReceiptComponentRenderer.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 4/12/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXReceiptComponentRenderer: NSObject {
    let FONT_SIZE : CGFloat = 14.0
    let LABEL_SIZE : CGFloat = 18.0
    
    func render(_ component: PXReceiptComponent) -> PXReceiptView{
        let receiptView = PXReceiptView()
        receiptView.translatesAutoresizingMaskIntoConstraints = false
        if let dateString = component.props.dateLabelString {
            let dateLabel = makeLabel(text: dateString)
            receiptView.addSubview(dateLabel)
            receiptView.dateLabel = dateLabel
            PXLayout.pinTop(view: dateLabel, to: receiptView, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.matchWidth(ofView: dateLabel, toView: receiptView).isActive = true
        }
        
        if let detailString = component.props.receiptDescriptionString {
            let detailLabel = makeLabel(text: detailString)
            receiptView.addSubview(detailLabel)
            receiptView.detailLabel = detailLabel
            PXLayout.pinBottom(view: detailLabel, to: receiptView, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.matchWidth(ofView: detailLabel, toView: receiptView).isActive = true
            PXLayout.put(view: detailLabel, onBottomOfLastViewOf: receiptView)?.isActive = true
        }
        
        
        
        return receiptView
    }
    
    
    func settupLabel() -> UILabel {
        let label = UILabel()
        label.font = Utils.getFont(size: FONT_SIZE)
        label.textColor = UIColor.pxBrownishGray
        label.textAlignment = .center
        return label
    }
    
    func makeLabel(text : String) -> UILabel {
        let label = settupLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        PXLayout.setHeight(owner: label, height: LABEL_SIZE).isActive = true
        return label
    }
}

class PXReceiptView : UIView {
    var dateLabel : UILabel?
    var detailLabel : UILabel?
}
