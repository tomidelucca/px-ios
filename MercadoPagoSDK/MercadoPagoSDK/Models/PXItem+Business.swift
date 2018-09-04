//
//  PXItem+Business.swift
//  MercadoPagoSDKV4
//
//  Created by Eden Torres on 04/09/2018.
//

import Foundation
extension PXItem {

    func validate() -> String? {
        if quantity <= 0 {
            return "La cantidad de items no es valida".localized
        }
        return nil
    }
}
