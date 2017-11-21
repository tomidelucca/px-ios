//
//  InstructionsContentComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsContentComponent: NSObject {
    var props: InstructionsContentProps

    init(props: InstructionsContentProps) {
        self.props = props
    }
    
    public func hasInfo() -> Bool {
        return !Array.isNullOrEmpty(props.instruction.info)
    }
    
    public func getInfoComponent() -> InstructionsInfoComponent {
        var content: [String] = []
        var info: [String] = props.instruction.info
        
        var title = ""
        var hasTitle = false
        if info.count == 1 || info.count > 1, info.indices.contains(1), info[1] != "" {
            title = info[0]
            hasTitle = true
        }
        
        var firstSpaceFound = false
        var secondSpaceFound = false
        var hasBottomDivider = false
        
        for text in info {
            if text.isEmpty {
                if firstSpaceFound {
                    secondSpaceFound = true
                } else {
                    firstSpaceFound = true
                }
            } else {
                if !hasTitle || firstSpaceFound, !secondSpaceFound {
                    content.append(text)
                } else {
                    hasBottomDivider = true
                }
            }
        }

        let infoProps = InstructionsInfoProps(infoTitle: title, infoContent: content, bottomDivider: hasBottomDivider)
        let infoComponent = InstructionsInfoComponent(props: infoProps)
        return infoComponent
    }
    
    public func getReferencesComponent() -> InstructionsReferencesComponent {
        var info: [String] = props.instruction.info
        var spacesFound = 0
        var title = ""
        
        for text in info {
            if text.isEmpty {
                spacesFound += 1
            } else if spacesFound == 2 {
                title = text
                break
            }
        }
        
        let referencesProps = InstructionsReferencesProps(title: title, references: props.instruction.references)
        let referencesComponent = InstructionsReferencesComponent(props: referencesProps)
        return referencesComponent
    }
//
//    public func getTertiaryInfoComponent() -> InstructionsTertiaryInfoComponent {
//
//    }
//
//    public func getAccreditationTimeComponent() -> InstructionsAccreditationTimeComponent {
//
//    }
//
//    public func getActionsComponent() -> InstructionsActionsComponent {
//
//    }
    
    public func hasReferences() -> Bool {
        return !Array.isNullOrEmpty(props.instruction.references)
    }
    
    public func hasTertiaryInfo() -> Bool {
        return !Array.isNullOrEmpty(props.instruction.tertiaryInfo)
    }
    
    public func hasAccreditationTime() -> Bool {
        return !Array.isNullOrEmpty(props.instruction.actions) || String.isNullOrEmpty(props.instruction.accreditationMessage)
    }
    
    public func hasActions() -> Bool {
        if !Array.isNullOrEmpty(props.instruction.actions) {
            for action in props.instruction.actions! {
                if action.tag == ActionTag.LINK.rawValue {
                    return true
                }
            }
        }
        return false
    }
    
    public func needsBottomMargin() -> Bool {
        return hasInfo() || hasReferences() || hasAccreditationTime()
    }
}
class InstructionsContentProps: NSObject {
    var instruction: Instruction
    init(instruction: Instruction) {
        self.instruction = instruction
    }
}
