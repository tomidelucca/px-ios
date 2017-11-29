//
//  PXInstructionsAccreditationCommentComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PXInstructionsAccreditationCommentComponent: NSObject, PXComponetizable {
    var props: InstructionsAccreditationCommentProps

    init(props: InstructionsAccreditationCommentProps) {
        self.props = props
    }
    func render() -> UIView {
       return InstructionsAccreditationCommentRenderer().render(instructionsAccreditationComment: self)
    }
}
class InstructionsAccreditationCommentProps: NSObject {
    var accreditationComment: String?
    init(accreditationComment: String?) {
        self.accreditationComment = accreditationComment
    }
}
