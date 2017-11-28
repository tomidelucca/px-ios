//
//  InstructionsActionRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsActionRenderer: NSObject {
    let CONTENT_WIDTH_PERCENT: CGFloat = 100.0
    let ACTION_LABEL_FONT_SIZE: CGFloat = 16.0
    let ACTION_LABEL_FONT_COLOR: UIColor = .px_blueMercadoPago()

    func render(instructionsAction: InstructionsActionComponent) -> UIView {
        let instructionsActionView = ActionView()
        instructionsActionView.translatesAutoresizingMaskIntoConstraints = false
        instructionsActionView.backgroundColor = .pxLightGray

        guard let label = instructionsAction.props.instructionActionInfo?.label, let tag = instructionsAction.props.instructionActionInfo?.tag, let url = instructionsAction.props.instructionActionInfo?.url else {
            return instructionsActionView
        }
        
        instructionsActionView.actionButton = buildActionButton(with: label, url: url, in: instructionsActionView)
        
        return instructionsActionView
    }

    func buildActionButton(with text: String, url: String, in superView: UIView) -> UIButton {
        let button = MPButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = Utils.getFont(size: ACTION_LABEL_FONT_SIZE)
        button.setTitleColor(ACTION_LABEL_FONT_COLOR, for: .normal)
        button.actionLink = url
        button.add(for: .touchUpInside) {
            if let URL = button.actionLink {
                self.goToURL(URL)
            }
        }
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
    
    func goToURL(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.openURL(url)
        }
    }
}

class ActionView: UIView {
    public var actionButton: UIButton?
}
