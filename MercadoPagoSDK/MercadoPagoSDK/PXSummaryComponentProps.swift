//
//  PXSummaryComponentProps.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 1/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXSummaryComponentProps : NSObject {
    
    let width: CGFloat
    let summaryViewModel: Summary
    let paymentData: PaymentData
    let totalAmount: Double
    
    init(summaryViewModel: Summary, paymentData: PaymentData, total: Double, width: CGFloat) {
        self.width = width
        self.summaryViewModel = summaryViewModel
        self.paymentData = paymentData
        self.totalAmount = total
    }
}
