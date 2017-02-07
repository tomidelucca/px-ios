//
//  Inflator.swift
//  MercadoPagoSDKExamples
//
//  Created by Eden Torres on 2/7/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoSDK

open class CustomInflator: NSObject, MPCustomInflator {
    
    var title = ""
    
    open func fillCell(cell: MPCustomTableViewCell){
        let customCell = cell as! CustomTableViewCell
        customCell.title.text = title
    }
    
    open func setTitle(text: String){
        self.title = text
    }
}
