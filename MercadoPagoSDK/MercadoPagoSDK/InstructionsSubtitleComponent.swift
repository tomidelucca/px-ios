//
//  InstructionsSubtitleComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsSubtitleComponent: NSObject {
    var props: InstructionsSubtitleProps
    
    init(props: InstructionsSubtitleProps) {
        self.props = props
    }
}
class InstructionsSubtitleProps: NSObject {
    var subtitle: String
    init(subtitle: String) {
        self.subtitle = subtitle
    }
}
