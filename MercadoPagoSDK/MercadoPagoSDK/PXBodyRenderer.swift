//
//  PXBodyRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class PXBodyRenderer: NSObject {

    func render(body: PXBodyComponent) -> PXBodyView {
        var content : UIView = UIView()
        if body.hasInstructions(), let instructionsComponent = body.getInstructionsComponent()  {
            return instructionsComponent.render() as! InstructionsView
        } else if body.props.paymentResult.isApproved() {
            return body.getPaymentMethodComponent().render() as! PXBodyView
        }
        let bodyView = PXBodyView()
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        return bodyView
    }
}

class PXBodyView: UIView {
}
