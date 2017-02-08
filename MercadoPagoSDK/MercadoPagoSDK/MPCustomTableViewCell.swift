//
//  CellProtocol.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/6/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

@objc
open class MPCustomTableViewCell: UITableViewCell{
    //var imageDelegate: bundle.CellProtocol?
    
//    open func getNib() -> UINib? {
//        return nib
//    }
//    
//    open func getHeigth() -> CGFloat {
//        return heigth
//    }
    
    func fillCell(customCell: MPCustomTableViewCell){
        customCell.fillContent()
    }
    
    open func fillContent() {
    
    }
    
}
import Foundation

@objc open class MPCustomCells : NSObject {
    open let cell: MPCustomTableViewCell
    open let inflator: MPCustomInflator
    
    public init (cell: MPCustomTableViewCell, inflator: MPCustomInflator){
        self.cell = cell
        self.inflator = inflator
    }
}
