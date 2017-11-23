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
<<<<<<< HEAD
=======
        
>>>>>>> b2a67b37e026f37134e7a09f7fc9cb02ba448adf
        if body.hasInstructions() {
            let instructionsRenderer = InstructionsRenderer()
            let instructionsView = instructionsRenderer.render(instructions: body.getInstructionsComponent())
            bodyView.addSubview(instructionsView)
            MPLayout.pinTop(view: instructionsView, to: bodyView).isActive = true
            MPLayout.pinBottom(view: instructionsView, to: bodyView).isActive = true
            MPLayout.centerHorizontally(view: instructionsView, to: bodyView).isActive = true
            MPLayout.equalizeWidth(view: instructionsView, to: bodyView).isActive = true
            
        }
        return bodyView
    }
}
