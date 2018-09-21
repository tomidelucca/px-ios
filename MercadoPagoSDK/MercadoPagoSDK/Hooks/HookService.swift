//
//  HookService.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 31/7/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final internal class PXDynamicScreens {

    var preReviewScreen: PXPreReviewScreen?
}

extension PXDynamicScreens {
    func setPreReviewScreen(screen: PXPreReviewScreen) {
        self.preReviewScreen = screen
    }

    func getPreReviewScreen() -> PXPreReviewScreen? {
        return preReviewScreen
    }
}
