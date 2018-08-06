//
//  PXAdvancedConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 30/7/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

public protocol PXAdvancedConfigurationProtocol {
    var bankDealsEnabled: Bool { get set }
    var escEnabled: Bool { get set }
    var binaryMode: Bool { get set }
    var reviewScreenPreference: ReviewScreenPreference { get set }
    var paymentResultScreenPreference: PaymentResultScreenPreference { get set }
    //func reviewScreenUIProtocol() -> PXReviewScreenUIProtocol?
    //func resultScreenUIProtocol() -> PXResultScreenUIProtocol?
}

extension PXAdvancedConfigurationProtocol {
    var bankDealsEnabled: Bool {
        get { return true } set { }
    }

    var escEnabled: Bool {
        get { return false } set { }
    }

    var binaryMode: Bool {
        get { return false } set { }
    }

    var reviewScreenPreference: ReviewScreenPreference {
        get { return ReviewScreenPreference() } set { }
    }

    var paymentResultScreenPreference: PaymentResultScreenPreference {
        get { return PaymentResultScreenPreference() } set { }
    }
}

final class PXAdvancedConfiguration: PXAdvancedConfigurationProtocol {
}
