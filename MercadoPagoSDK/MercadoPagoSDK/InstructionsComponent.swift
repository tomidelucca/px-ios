//
//  InstructionsComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsComponent: NSObject {
    var props: InstructionsProps
    
    init(props: InstructionsProps) {
        self.props = props
    }
    
    public func getSubtitleComponent() -> InstructionsSubtitleComponent {
        let instructionsSubtitleProps = InstructionsSubtitleProps(subtitle: props.instruction.subtitle!)
        let instructionsSubtitleComponent = InstructionsSubtitleComponent(props: instructionsSubtitleProps)
        return instructionsSubtitleComponent
    }
    
    public func getContentComponent() -> InstructionsContentComponent {
        let instructionsContentProps = InstructionsContentProps(instruction: props.instruction)
        let instructionsContentComponent = InstructionsContentComponent(props: instructionsContentProps)
        return instructionsContentComponent
    }
    
    public func getSecondaryInfoComponent() -> InstructionsSecondaryInfoComponent {
        let instructionsSecondaryInfoProps = InstructionsSecondaryInfoProps(secondaryInfo: props.instruction.secondaryInfo!)
        let instructionsSecondaryInfoComponent = InstructionsSecondaryInfoComponent(props: instructionsSecondaryInfoProps)
        return instructionsSecondaryInfoComponent
    }
    
    public func hasSubtitle() -> Bool {
        return props.instruction.subtitle != nil
    }
    
    public func hasSecondaryInfo() -> Bool {
        return props.instruction.secondaryInfo != nil
    }
    
    public func shouldShowEmailInSecondaryInfo() -> Bool {
        return (props.processingMode == ProcessingMode.aggregator.rawValue)
    }
}
class InstructionsProps: NSObject {
    var instruction: Instruction
    var processingMode: String
    init(instruction: Instruction, processingMode: String) {
        self.instruction = instruction
        self.processingMode = processingMode
    }
}
