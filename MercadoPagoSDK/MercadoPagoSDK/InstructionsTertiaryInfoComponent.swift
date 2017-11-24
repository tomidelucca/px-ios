//
//  InstructionsTertiaryInfoComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsTertiaryInfoComponent: NSObject, PXComponetizable {
    var props: InstructionsTertiaryInfoProps
    
    init(props: InstructionsTertiaryInfoProps) {
        self.props = props
    }
    func render() -> UIView {
        return InstructionsTertiaryInfoRenderer().render(instructionsTertiaryInfo: self)
    }
}
class InstructionsTertiaryInfoProps: NSObject {
    var tertiaryInfo: [String]?
    init(tertiaryInfo: [String]?) {
        self.tertiaryInfo = tertiaryInfo
    }
}
