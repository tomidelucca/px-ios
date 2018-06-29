//
//  InitFlowModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 27/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServices

final class InitFlowModel: NSObject, PXFlowModel {

    internal enum Steps: String {
        case SERVICE_GET_PREFERENCE
        case ACTION_VALIDATE_PREFERENCE
        case SERVICE_GET_DIRECT_DISCOUNT
        case SERVICE_GET_PAYMENT_METHODS
        case SERVICE_PAYMENT_METHOD_PLUGIN_INIT
        case FINISH
    }

    private let mercadoPagoServicesAdapter = MercadoPagoServicesAdapter(servicePreference: MercadoPagoCheckoutViewModel.servicePreference)

    private var needLoadPreference: Bool = false

    public func nextStep() -> Steps {
        if needLoadPreference {
            needLoadPreference = false
            return .SERVICE_GET_PREFERENCE
        }

        return .FINISH
    }
}

// MARK: Setters
extension InitFlowModel {
    func setPreferenceLoadStatus(loaded: Bool) {
        needLoadPreference = loaded
    }
}

// MARK: Needs methods
extension InitFlowModel {

}
