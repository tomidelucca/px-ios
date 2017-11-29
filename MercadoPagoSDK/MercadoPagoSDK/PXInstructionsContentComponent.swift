//
//  PXInstructionsContentComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

public class PXInstructionsContentComponent: NSObject, PXComponetizable {
    var props: InstructionsContentProps

    init(props: InstructionsContentProps) {
        self.props = props
    }

    public func hasInfo() -> Bool {
        return !Array.isNullOrEmpty(props.instruction.info)
    }

    func getInfoComponent() -> InstructionsInfoComponent? {
        var content: [String] = []
        var info: [String] = props.instruction.info

        var title = ""
        var hasTitle = false
        if info.count == 1 || (info.count > 1 && info[1] == "") {
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
                if !hasTitle || (firstSpaceFound && !secondSpaceFound) {
                    content.append(text)
                } else if firstSpaceFound && secondSpaceFound {
                    hasBottomDivider = true
                }
            }
        }

        let infoProps = InstructionsInfoProps(infoTitle: title, infoContent: content, bottomDivider: hasBottomDivider)
        let infoComponent = InstructionsInfoComponent(props: infoProps)
        return infoComponent
    }

    
    func getReferencesComponent() -> InstructionsReferencesComponent? {
        let info: [String] = props.instruction.info
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
    
    func getTertiaryInfoComponent() -> InstructionsTertiaryInfoComponent? {
        let tertiaryInfoProps = InstructionsTertiaryInfoProps(tertiaryInfo: props.instruction.tertiaryInfo)
        let tertiaryInfoComponent = InstructionsTertiaryInfoComponent(props: tertiaryInfoProps)
        return tertiaryInfoComponent
    }

    func getAccreditationTimeComponent() -> InstructionsAccreditationTimeComponent? {
        let accreditationTimeProps = InstructionsAccreditationTimeProps(accreditationMessage: props.instruction.accreditationMessage, accreditationComments: props.instruction.accreditationComment)
        let accreditationTimeComponent = InstructionsAccreditationTimeComponent(props: accreditationTimeProps)
        return accreditationTimeComponent
    }

    
    func getActionsComponent() -> InstructionsActionsComponent? {
        let actionsProps = InstructionsActionsProps(instructionActions: props.instruction.actions)
        let actionsComponent = InstructionsActionsComponent(props: actionsProps)
        return actionsComponent
    }

    public func hasReferences() -> Bool {
        return !Array.isNullOrEmpty(props.instruction.references)
    }

    public func hasTertiaryInfo() -> Bool {
        return !Array.isNullOrEmpty(props.instruction.tertiaryInfo)
    }

    public func hasAccreditationTime() -> Bool {
        return !Array.isNullOrEmpty(props.instruction.accreditationComment) || !String.isNullOrEmpty(props.instruction.accreditationMessage)
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
    
    public func render() -> UIView {
        return InstructionsContentRenderer().render(instructionsContent: self)
    }
}
public class InstructionsContentProps: NSObject {
    var instruction: Instruction
    init(instruction: Instruction) {
        self.instruction = instruction
    }
}
