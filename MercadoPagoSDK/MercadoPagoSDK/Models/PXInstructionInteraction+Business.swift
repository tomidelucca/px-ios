//
//  PXInstructionInteraction+Business.swift
//  MercadoPagoSDK
//
//  Created by Marcelo Oscar José on 25/10/2018.
//

import Foundation

extension PXInstructionInteraction {
    func getFullInteractionValue() -> String {
        if String.isNullOrEmpty(separator) {
            self.separator = ""
        }
        if fieldValue.count == 0 {
            return ""
        }
        var interactionFullValue: String = fieldValue.reduce("", {($0 as String) + self.separator + $1})
        if self.separator != "" {
            interactionFullValue = String(interactionFullValue.dropFirst())
        }
        return interactionFullValue
    }
}
