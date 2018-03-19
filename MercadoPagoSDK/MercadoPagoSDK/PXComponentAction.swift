//
//  PXComponentAction.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 27/2/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

class PXComponentAction: NSObject {
    var label: String
    var action : (() -> Void)
    init(label: String, action:  @escaping (() -> Void)) {
        self.label = label
        self.action = action
    }
}
