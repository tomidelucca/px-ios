//
//  CellProtocol.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/6/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

import Foundation

@objc open class MPCustomCell : NSObject {
    
    open let contentProvider: MPCellContentProvider
    
    public init (contentProvider: MPCellContentProvider){
        self.contentProvider = contentProvider
    }
}
