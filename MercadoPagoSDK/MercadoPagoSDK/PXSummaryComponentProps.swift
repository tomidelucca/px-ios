//
//  PXSummaryComponentProps.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 1/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXSummaryComponentProps : NSObject {
    
    let summary: Summary
    let paymentData: PaymentData
    let totalAmount: Double
    
    init(summary: Summary, paymentData: PaymentData, total: Double) {
        self.summary = summary
        self.paymentData = paymentData
        self.totalAmount = total
    }
}
