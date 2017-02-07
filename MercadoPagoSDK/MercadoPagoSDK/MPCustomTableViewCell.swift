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
    
    var nib: UINib?
    var heigth: CGFloat = 0.0
    
    open func setNib(uiNib: UINib) {
        nib = uiNib
    }
    
    open func getNib() -> UINib? {
        return nib
    }
    
    open func setHeigth(heigth: CGFloat) {
        self.heigth = heigth
    }
    
    open func getHeigth() -> CGFloat {
        return heigth
    }
    
    func fillCell(customCell: MPCustomTableViewCell){
        customCell.fillContent()
    }
    
    open func fillContent() {
    
    }
    
}

open class MPCustomCells {
    open let cell: MPCustomTableViewCell
    open let inflator: MPCustomInflator
    
    public init (cell: MPCustomTableViewCell, inflator: MPCustomInflator){
        self.cell = cell
        self.inflator = inflator
    }
}
