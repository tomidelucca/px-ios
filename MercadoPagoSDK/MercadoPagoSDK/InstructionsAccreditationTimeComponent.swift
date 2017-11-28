//
//  InstructionsAccreditationTimeComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsAccreditationTimeComponent: NSObject, PXComponetizable {
    var props: InstructionsAccreditationTimeProps

    init(props: InstructionsAccreditationTimeProps) {
        self.props = props
    }
    
    public func getAccreditationCommentComponents() -> [InstructionsAccreditationCommentComponent] {
        var accreditationCommentComponents: [InstructionsAccreditationCommentComponent] = []
        if let comments = props.accreditationComments, !comments.isEmpty {
            for comment in comments {
                let accreditationCommentProps = InstructionsAccreditationCommentProps(accreditationComment: comment)
                let accreditationCommentComponent = InstructionsAccreditationCommentComponent(props: accreditationCommentProps)
                accreditationCommentComponents.append(accreditationCommentComponent)
            }
        }
        return accreditationCommentComponents
    }
    
    func render() -> UIView {
        return InstructionsAccreditationTimeRenderer().render(instructionsAccreditationTime: self)
    }
}
class InstructionsAccreditationTimeProps: NSObject {
    var accreditationMessage: String?
    var accreditationComments: [String]?
    init(accreditationMessage: String?, accreditationComments: [String]?) {
        self.accreditationMessage = accreditationMessage
        self.accreditationComments = accreditationComments
    }
}
