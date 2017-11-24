//
//  InstructionsAccreditationTimeComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsAccreditationTimeComponent: NSObject, PXComponetizable {
    var props: InstructionsAccreditationTimeProps
    
    init(props: InstructionsAccreditationTimeProps) {
        self.props = props
    }
    func render() -> UIView {
        return InstructionsAccreditationTimeRenderer().render(instructionsAccreditationTime: self)
    }
}
class InstructionsAccreditationTimeProps: NSObject {
    var accreditationMessage: String?
    var accreditationComments: [String]?
    init(accreditationMessage: String?, accreditationComments: [String]?) {
        self.accreditationMessage = accreditationMessage
        self.accreditationComments = accreditationComments
    }
}
