//
//  InstructionsSubtitleRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsSubtitleRenderer: NSObject {
    
    func render(instructionsSubtitle: InstructionsSubtitleComponent) -> UIView {
        let instructionsSubtitleView = UIView()
        instructionsSubtitleView.translatesAutoresizingMaskIntoConstraints = false
        
        return instructionsSubtitleView
    }
}
