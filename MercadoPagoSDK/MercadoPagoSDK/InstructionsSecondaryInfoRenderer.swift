//
//  InstructionsSecondaryInfoRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsSecondaryInfoRenderer: NSObject {
    
    func render(instructionsSecondaryInfo: InstructionsSecondaryInfoComponent) -> UIView {
        let instructionsSecondaryInfoView = UIView()
        instructionsSecondaryInfoView.translatesAutoresizingMaskIntoConstraints = false
        instructionsSecondaryInfoView.backgroundColor = .red
        
        return instructionsSecondaryInfoView
    }
}
