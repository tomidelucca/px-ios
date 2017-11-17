//
//  InstructionsReferencesComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsReferencesComponent: NSObject {
    var props: InstructionsReferencesProps
    
    init(props: InstructionsReferencesProps) {
        self.props = props
    }
}
class InstructionsReferencesProps: NSObject {
    var title: String?
    var references: [InstructionReference]?
    init(title: String, references: [InstructionReference]?) {
        self.title = title
        self.references = references
    }
}
