//
//  BodyRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class BodyRenderer: NSObject {

    func render(body: BodyComponent) -> BodyView {
        var bodyView = BodyView()
        if body.hasInstructions(), let instructionsComponent = body.getInstructionsComponent() {
            bodyView = instructionsComponent.render() as! InstructionsView
        }
        return bodyView
    }
}

class BodyView: UIView {
}
