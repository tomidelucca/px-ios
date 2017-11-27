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
        let bodyView = BodyView()
        bodyView.translatesAutoresizingMaskIntoConstraints = false

        if body.hasInstructions(), let instructionsComponent = body.getInstructionsComponent() {
            bodyView.instructionsView = instructionsComponent.render()
            bodyView.addSubview(bodyView.instructionsView!)
            MPLayout.pinTop(view: bodyView.instructionsView!, to: bodyView).isActive = true
            MPLayout.pinBottom(view: bodyView.instructionsView!, to: bodyView).isActive = true
            MPLayout.centerHorizontally(view: bodyView.instructionsView!, to: bodyView).isActive = true
            MPLayout.equalizeWidth(view: bodyView.instructionsView!, to: bodyView).isActive = true
        }
        return bodyView
    }
}

class BodyView: UIView {
    public var instructionsView: UIView?
}
