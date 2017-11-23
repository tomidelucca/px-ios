//
//  InstructionsActionRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsActionRenderer: NSObject {
    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 30.0
    let M_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let ZERO_MARGIN: CGFloat = 0.0
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let ACTION_LABEL_FONT_SIZE: CGFloat = 16.0
    let ACTION_LABEL_FONT_COLOR: UIColor = .px_blueMercadoPago()
    
    func render(instructionsAction: InstructionsActionComponent) -> UIView {
        let instructionsActionView = ActionView()
        instructionsActionView.translatesAutoresizingMaskIntoConstraints = false
        instructionsActionView.backgroundColor = .pxLightGray
        
        guard let label = instructionsAction.props.instructionActionInfo?.label, let tag = instructionsAction.props.instructionActionInfo?.tag, let url = instructionsAction.props.instructionActionInfo?.url else {
            return instructionsActionView
        }
        
        if tag == ActionTag.LINK.rawValue {
            instructionsActionView.actionButton = buildActionButton(with: label, url: url, in: instructionsActionView)
        }

        return instructionsActionView
    }
    
    func buildActionButton(with text: String, url: String, in superView: UIView) -> MPButton {
        let button = MPButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = Utils.getFont(size: ACTION_LABEL_FONT_SIZE)
        button.setTitleColor(ACTION_LABEL_FONT_COLOR, for: .normal)
        button.actionLink = url
        button.addTarget(self, action: #selector(self.goToURL), for: .touchUpInside)
        superView.addSubview(button)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100
        
        let height = UILabel.requiredHeight(forText: text, withFont: Utils.getFont(size: ACTION_LABEL_FONT_SIZE), inNumberOfLines: 0, inWidth: screenWidth)
        MPLayout.setHeight(owner: button, height: height).isActive = true
        MPLayout.setWidth(ofView: button, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: button, to: superView).isActive = true
        MPLayout.pinTop(view: button, to: superView).isActive = true
        MPLayout.pinBottom(view: button, to: superView).isActive = true
        
        return button
    }
    
    func goToURL(sender: MPButton!) {   if let link = sender.actionLink {
        UIApplication.shared.openURL(URL(string: link)!)
        }
    }
}

class ActionView: UIView {
    public var actionButton: MPButton?
}


