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
    open let cell: ReviewableCell
    open let inflator: MPCustomInflator
    
    public init (cell: ReviewableCell, inflator: MPCustomInflator){
        self.cell = cell
        self.inflator = inflator
    }
}

@objc public protocol ReviewableCell : NSObjectProtocol {
    
    func getNib() -> UINib
    
    func getHeigth() -> CGFloat
    
}
