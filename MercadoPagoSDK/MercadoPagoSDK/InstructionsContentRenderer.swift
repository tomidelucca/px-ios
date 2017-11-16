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
        let instructionsContentView = UIView()
        instructionsContentView.translatesAutoresizingMaskIntoConstraints = false
        instructionsContentView.backgroundColor = .blue
        return instructionsContentView
    }
}
