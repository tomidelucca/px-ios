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
        var content : UIView = UIView()
        if body.hasInstructions(), let instructionsComponent = body.getInstructionsComponent()  {
            return instructionsComponent.render() as! InstructionsView
        } else if body.props.paymentResult.isApproved() {
            return body.getPaymentMethodComponent().render() as! BodyView
        }
        let bodyView = BodyView()
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        return bodyView
    }
}


class BodyView: UIView {

}
