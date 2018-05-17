//
//  File.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 17/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

class PXXibComponent: UIView {
    func loadXibComponent(xibComponentizableClass: PXXibComponentizable) {
        if let bundle = MercadoPago.getBundle() {
            bundle.loadNibNamed(xibComponentizableClass.xibName(), owner: xibComponentizableClass, options: nil)
            if let classView = xibComponentizableClass as? UIView {
                let contentView = xibComponentizableClass.containerView()
                classView.addSubview(contentView)
                contentView.frame = classView.bounds
                contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            }
        }
    }
}
