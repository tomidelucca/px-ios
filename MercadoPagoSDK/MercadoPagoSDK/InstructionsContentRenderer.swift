//
//  InstructionsContentRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsContentRenderer: NSObject {
    
    func render(instructionsContent: InstructionsContentComponent) -> UIView {
        let instructionsContentView = ContentView()
        instructionsContentView.translatesAutoresizingMaskIntoConstraints = false
        instructionsContentView.backgroundColor = .blue
        
        if instructionsContent.hasInfo() {
            let instructionsInfoRenderer = InstructionsInfoRenderer()
            instructionsContentView.infoView = instructionsInfoRenderer.render(instructionsInfo: instructionsContent.getInfoComponent())
            instructionsContentView.addSubview(instructionsContentView.infoView!)
            MPLayout.pinTop(view: instructionsContentView.infoView!, to: instructionsContentView).isActive = true
//            MPLayout.setHeight(owner: instructionsContentView.infoView!, height: 30).isActive = true
            MPLayout.centerHorizontally(view: instructionsContentView.infoView!, to: instructionsContentView).isActive = true
            MPLayout.equalizeWidth(view: instructionsContentView.infoView!, to: instructionsContentView).isActive = true
        }
        
        return instructionsContentView
    }
}

class ContentView: UIView {
    public var infoView: UIView?
    public var referencesView: UIView?
    public var tertiaryInfoView: UIView?
    public var accreditationTimeView: UIView?
    public var actionsView: UIView?
}
