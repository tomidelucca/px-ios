//
//  PXCustomTermsAndConditionView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 7/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoPXTrackingV4

final class PXCustomTermsAndConditionView: PXTermsAndConditionView {

    private var text: NSMutableAttributedString
    private var url: URL?

    init(text: NSMutableAttributedString, url: URL? = nil, shouldAddMargins: Bool = true, screenTitle: String = "") {
        self.text = text
        self.url = url
        super.init(shouldAddMargins: shouldAddMargins)
        self.SCREEN_NAME = screenTitle
        self.SCREEN_TITLE = screenTitle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func getTyCText() -> NSMutableAttributedString {
        return text
    }

    override func handleTap(_ sender: UITapGestureRecognizer) {
        if let url = url {
            delegate?.shouldOpenTermsCondition(SCREEN_TITLE, screenName: SCREEN_NAME, url: url)
        }
    }
}

