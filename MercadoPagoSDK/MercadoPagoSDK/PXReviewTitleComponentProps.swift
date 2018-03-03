//
//  PXReviewTitleComponentProps.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 3/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXReviewTitleComponentProps : NSObject {
    
    let reviewTitle: String
    let titleColor: UIColor
    let backgroundColor: UIColor
    
    init(withTitle: String, titleColor: UIColor, backgroundColor: UIColor) {
        self.reviewTitle = withTitle
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
    }
}
