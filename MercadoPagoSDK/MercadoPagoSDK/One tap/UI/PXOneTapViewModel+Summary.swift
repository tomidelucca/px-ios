//
//  PXOneTapViewModel+Summary.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 22/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

extension PXOneTapViewModel {
    //TODO: Align and check. Remove mocked data.
    func getSummaryProps() -> [PXSummaryRowProps]? {
        return [(title: "AySA", subTitle: "Factura agua", rightText: "$ 1200", backgroundColor: nil), (title: "Edenor", subTitle: "Pago de luz mensual", rightText: "$ 400", backgroundColor: nil)]
    }
}
