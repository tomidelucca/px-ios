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

        var content : UIView = UIView()
        if body.hasInstructions() {
            content = body.getInstructionsComponent().render()
        } else if body.props.paymentResult.isApproved() {
            content = body.getPaymentMethodComponent().render()
        }
        bodyView.addSubview(content)
        MPLayout.pinTop(view: content, to: bodyView).isActive = true
        MPLayout.pinBottom(view: content, to: bodyView).isActive = true
        MPLayout.centerHorizontally(view: content, to: bodyView).isActive = true
        MPLayout.equalizeWidth(view: content, to: bodyView).isActive = true
        return bodyView
    }
}
