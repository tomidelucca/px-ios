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
    open let cell: MPReviewableCell
    open let contentProvider: MPCellContentProvider
    
    public init (cell: MPReviewableCell, contentProvider: MPCellContentProvider){
        self.cell = cell
        self.contentProvider = contentProvider
    }
}

@objc public protocol MPReviewableCell : NSObjectProtocol {
    
    func getNib() -> UINib
    
    func getHeigth() -> CGFloat
    
}
