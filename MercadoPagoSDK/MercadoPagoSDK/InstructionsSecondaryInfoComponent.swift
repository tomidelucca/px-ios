//
//  InstructionsSecondaryInfoComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsSecondaryInfoComponent: NSObject {
    var props: InstructionsSecondaryInfoProps
    
    init(props: InstructionsSecondaryInfoProps) {
        self.props = props
    }
}
class InstructionsSecondaryInfoProps: NSObject {
    var secondaryInfo: [String]
    init(secondaryInfo: [String]) {
        self.secondaryInfo = secondaryInfo
    }
}
