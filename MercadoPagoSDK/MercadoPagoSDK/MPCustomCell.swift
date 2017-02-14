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
    
    private let contentProvider: MPCellContentProvider
    
    public init (contentProvider: MPCellContentProvider){
        self.contentProvider = contentProvider
    }
    
    public func getNib() -> UINib {
        return contentProvider.getNib()
    }
    
    public func getHeight() -> CGFloat {
        return contentProvider.getHeight()
    }
    
    public func setDelegate(delegate : MPCustomRowDelegate) {
        self.contentProvider.delegate = delegate
    }
    
    public func fillCell(cell : UITableViewCell) {
        self.contentProvider.fillCell(cell : cell)
    }
}
