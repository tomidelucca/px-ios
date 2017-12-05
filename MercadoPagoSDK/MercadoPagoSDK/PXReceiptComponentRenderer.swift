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
    
    func render(_ component: PXReceiptComponent) -> PXRecieptView{
        let recieptView = PXRecieptView()
        recieptView.translatesAutoresizingMaskIntoConstraints = false
        if let dateString = component.props.dateLabelString {
            let dateLabel = makeLabel(text: dateString)
            recieptView.addSubview(dateLabel)
            recieptView.dateLabel = dateLabel
            PXLayout.pinTop(view: dateLabel, to: recieptView, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.equalizeWidth(view: dateLabel, to: recieptView).isActive = true
        }
        
        if let detailString = component.props.recieptDescriptionString {
            let detailLabel = makeLabel(text: detailString)
            recieptView.addSubview(detailLabel)
            recieptView.detailLabel = detailLabel
            PXLayout.pinBottom(view: detailLabel, to: recieptView, withMargin: PXLayout.S_MARGIN).isActive = true
            PXLayout.equalizeWidth(view: detailLabel, to: recieptView).isActive = true
            PXLayout.put(view: detailLabel, onBottomOfLastViewOf: recieptView)?.isActive = true
        }
        
        
        
        return recieptView
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

class PXRecieptView : UIView {
    var dateLabel : UILabel?
    var detailLabel : UILabel?
}
