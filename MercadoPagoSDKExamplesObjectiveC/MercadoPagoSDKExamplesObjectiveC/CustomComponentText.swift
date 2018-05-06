//
//  CustomComponentText.swift
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Demian Tejo on 6/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

@objc class CustomComponentText: NSObject, PXComponentizable {
    let HEIGHT : CGFloat = 80.0
    func render() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let screenSize = UIScreen.main.bounds
        PXLayout.setWidth(owner: view, width: screenSize.width).isActive = true
        PXLayout.setHeight(owner: view, height: 80).isActive = true
        let textLabel = UILabel()
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.text = "Sumaste 150 Km YPF Serviclub con tu carga. ¡Ya tienes 2.500 km!"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        PXLayout.matchHeight(ofView: textLabel,toView: view, withPercentage: 80).isActive = true
        PXLayout.matchWidth(ofView: textLabel,toView: view, withPercentage: 90).isActive = true
        PXLayout.centerVertically(view: textLabel).isActive = true
        PXLayout.centerHorizontally(view: textLabel).isActive = true
        return view
    }
    

}
