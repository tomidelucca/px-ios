//
//  IdentificationCardView.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 5/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class IdentificationCardView: UIView {
var view:UIView!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib ()
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "IdentificationCardView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        //       view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view)
    }

}
