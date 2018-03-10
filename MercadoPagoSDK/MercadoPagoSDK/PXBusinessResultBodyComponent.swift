//
//  PXBusinessResultBodyComponent.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 10/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

class PXBusinessResultBodyComponent: NSObject, PXComponentizable {
   
    let instructionLabel : String
    
    init(instructionLabel: String) {
        self.instructionLabel = instructionLabel
    }
    
    func render() -> UIView {
        let componentView = PXComponentView()
        let titleLabel = UILabel()
        titleLabel.text = "Que puedo hacer?".localized
        titleLabel.textAlignment = .center
        componentView.addSubview(titleLabel)
        PXLayout.pinTop(view: titleLabel).isActive = true
        PXLayout.matchWidth(ofView: titleLabel).isActive = true
        PXLayout.setHeight(owner: titleLabel, height: 50).isActive = true
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = instructionLabel
        subtitleLabel.textAlignment = .center
        componentView.addSubviewToButtom(subtitleLabel)
        PXLayout.matchWidth(ofView: subtitleLabel).isActive = true
        PXLayout.setHeight(owner: subtitleLabel, height: 50).isActive = true
        
        PXLayout.pinLastSubviewToBottom(view: componentView)?.isActive = true
        PXLayout.setHeight(owner: componentView, height: 100).isActive = true
        return componentView
    }

}
