//
//  PXTotalRowProps.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 23/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXTotalRowProps: NSObject {
    var title: NSAttributedString
    var value: NSAttributedString
    var action: PXComponentAction?
    var actionValue: NSAttributedString?
    init(title: NSAttributedString, value: NSAttributedString, action: PXComponentAction? = nil, actionValue: NSAttributedString? = nil) {
        self.title = title
        self.value = value
        self.action = action
        self.actionValue = actionValue
    }
}
