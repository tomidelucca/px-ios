//
//  InitFlowViewModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 27/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class InitFlowViewModel: NSObject, PXFlowModel {

    enum Steps: String {
        case finish
    }

    let mercadoPagoServicesAdapter = MercadoPagoServicesAdapter(servicePreference: MercadoPagoCheckoutViewModel.servicePreference)

    //override init() {}

    public func nextStep() -> Steps {
        // Need()
        return .finish
    }
}

// MARK: Needs methods
extension InitFlowViewModel {

}
