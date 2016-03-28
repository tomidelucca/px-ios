//
//  MPTextField.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 3/28/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class MPTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect){
        super.init(frame: frame)
        MercadoPagoUIViewController.loadFont("ProximaNova-Light")
        if(self.font != nil) {
            self.font = UIFont(name: "ProximaNova-Light", size: (self.font?.pointSize)!)
            
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MercadoPagoUIViewController.loadFont("ProximaNova-Light")
        if(self.font != nil) {
            self.font = UIFont(name: "ProximaNova-Light", size: (self.font?.pointSize)!)
            
        }
    }

}
