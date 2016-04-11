//
//  MPFlowController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 21/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class MPFlowController: NSObject {

    static var sharedInstance = MPFlowController()
    
    var navigationController : UINavigationController?
    
    public class func createNavigationControllerWith(rootViewController : UIViewController) -> UINavigationController {
        self.sharedInstance.navigationController = UINavigationController(rootViewController : rootViewController)
        return sharedInstance.navigationController!
    }
    
    public class func push(viewController : UIViewController, animated : Bool = true) {
        self.sharedInstance.navigationController?.pushViewController(viewController, animated: animated)
    }

    public class func pop(animated : Bool) {
        self.sharedInstance.navigationController?.popViewControllerAnimated(animated)
    }
    
    public class func dismiss(flag : Bool){
        self.sharedInstance.navigationController!.dismissViewControllerAnimated(flag) { () -> Void in
            // Override sharedInstance
            self.sharedInstance = MPFlowController()
        }
    }
    
    public class func isRoot(viewController : UIViewController) -> Bool {
        if self.sharedInstance.navigationController !=  nil && self.sharedInstance.navigationController!.viewControllers.count > 0 && self.sharedInstance.navigationController!.viewControllers[0] == viewController {
            return true
        }
        return false
    }

    public class func popToRoot(animated : Bool) {
        self.sharedInstance.navigationController?.popToRootViewControllerAnimated(animated)
    }
}
