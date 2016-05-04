//
//  ViewUtil.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 21/4/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

class ViewUtils {
    
    class func getTableCellSeparatorLineView(x : CGFloat, y : CGFloat, width : CGFloat, height : CGFloat) -> UIView {
        let separatorLineView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        separatorLineView.layer.zPosition = 1
        separatorLineView.backgroundColor = UIColor().grayTableSeparator()
        return separatorLineView
    }
    
    class func addStatusBar(view : UIView, color : UIColor) {
        let addStatusBar = UIView(frame: CGRectMake(0, 0, view.bounds.width, 20))
        addStatusBar.backgroundColor = color
        view.addSubview(addStatusBar)
    }
    
}
