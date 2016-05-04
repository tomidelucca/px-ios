//
//  MPFlowController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 2/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class MPFlowController: NSObject {
    
    static var sharedInstance = MPFlowController()
    
    var navigationController : UINavigationController?
    
    public class func createNavigationControllerWith(rootViewController : UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController : rootViewController)
        return nav
    }
    
}
