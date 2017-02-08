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
    
    public init(uiNib : UINib, heigth: CGFloat) {
        super.init(style: .default, reuseIdentifier: "identifier")
        self.nib = uiNib
        self.heigth = heigth
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func getNib() -> UINib? {
        return nib
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

@objc open class MPCustomCells : NSObject {
    open let cell: MPCustomTableViewCell
    open let inflator: MPCustomInflator
    
    public init (cell: MPCustomTableViewCell, inflator: MPCustomInflator){
        self.cell = cell
        self.inflator = inflator
    }
}
