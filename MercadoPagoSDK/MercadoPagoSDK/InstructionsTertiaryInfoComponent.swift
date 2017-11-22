//
//  InstructionsTertiaryInfoComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsTertiaryInfoComponent: NSObject {
    var props: InstructionsTertiaryInfoProps
    
    init(props: InstructionsTertiaryInfoProps) {
        self.props = props
    }
}
class InstructionsTertiaryInfoProps: NSObject {
    var tertiaryInfo: [String]?
    init(tertiaryInfo: [String]?) {
        self.tertiaryInfo = tertiaryInfo
    }
}
