//
//  BodyRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class BodyRenderer: NSObject {

    func render(body: BodyComponent) -> UIView {
        let bodyView = UIView()
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.backgroundColor = .red
        
        if body.hasInstructions() {
            let instructionsRenderer = InstructionsRenderer()
            let instructionsView = instructionsRenderer.render(instructions: body.getInstructionsComponent())
            bodyView.addSubview(instructionsView)
            MPLayout.equalizeWidth(view: instructionsView, to: bodyView).isActive = true
            MPLayout.equalizeHeight(view: instructionsView, to: bodyView).isActive = true
            MPLayout.centerHorizontally(view: instructionsView, to: bodyView).isActive = true
            MPLayout.centerVertically(view: instructionsView, into: bodyView).isActive = true
        }
        
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return bodyView
    }
}
