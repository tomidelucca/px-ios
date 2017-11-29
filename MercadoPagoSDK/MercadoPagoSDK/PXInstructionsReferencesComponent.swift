//
//  PXInstructionsReferencesComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsReferencesComponent: NSObject, PXComponetizable {
    var props: PXInstructionsReferencesProps

    init(props: PXInstructionsReferencesProps) {
        self.props = props
    }
    
    public func getReferenceComponents() -> [InstructionReferenceComponent] {
        var referenceComponents: [InstructionReferenceComponent] = []
        if let references = props.references, !references.isEmpty {
            for reference in references {
                let referenceProps = InstructionReferenceProps(reference: reference)
                let referenceComponent = InstructionReferenceComponent(props: referenceProps)
                referenceComponents.append(referenceComponent)
            }
        }
        return referenceComponents
    }
    
    func render() -> UIView {
        return InstructionsReferencesRenderer().render(instructionsReferences: self)
    }
}
class PXInstructionsReferencesProps: NSObject {
    var title: String?
    var references: [InstructionReference]?
    init(title: String, references: [InstructionReference]?) {
        self.title = title
        self.references = references
    }
}
