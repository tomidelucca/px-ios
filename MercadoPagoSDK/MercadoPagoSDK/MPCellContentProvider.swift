//
//  MPCustomInflator.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/7/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
@objc
public protocol MPCellContentProvider : NSObjectProtocol {
    
    weak var delegate : MPCustomRowDelegate? { set get }
    
    func fillCell(cell: UITableViewCell)
    
    func getNib() -> UINib
    
    func getHeight() -> CGFloat
}
