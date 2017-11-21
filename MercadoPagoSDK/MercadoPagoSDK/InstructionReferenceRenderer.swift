//
//  InstructionReferenceRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionReferenceRenderer: NSObject {
    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 30.0
    let M_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let ZERO_MARGIN: CGFloat = 0.0
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let TITLE_LABEL_FONT_SIZE: CGFloat = 20.0
    let TITLE_LABEL_FONT_COLOR: UIColor = .pxBlack
    let INFO_LABEL_FONT_SIZE: CGFloat = 16.0
    let INFO_LABEL_FONT_COLOR: UIColor = .pxBrownishGrey
    
    func render(instructionReference: InstructionReferenceComponent) -> UIView {
        let viw = UIView()
        viw.translatesAutoresizingMaskIntoConstraints = false
        MPLayout.setHeight(owner: viw, height: 50).isActive = true

        return viw
    }
}

class ReferenceView: UIView {
    public var titleLabel: UILabel?
    public var referencesComponents: [UIView]?
}
