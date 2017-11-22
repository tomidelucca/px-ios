//
//  InstructionsAccreditationTimeComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsAccreditationTimeComponent: NSObject {
    var props: InstructionsAccreditationTimeProps
    
    init(props: InstructionsAccreditationTimeProps) {
        self.props = props
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
