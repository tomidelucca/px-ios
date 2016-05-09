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
    var currentNavigationController : UINavigationController?
    
    public class func createNavigationControllerWith(rootViewController : UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController : rootViewController)
        
        return nav
    }
    
   /* public class func presentViewController(nv : UINavigationController, callback : (() -> Void)?){
        self.sharedInstance.currentNavigationController?.presentingViewController?.presentViewController(nv, animated: true, completion: {
            
        })
    }
    
    public class func push(viewController : UIViewController, animated : Bool = true) {
        self.sharedInstance.currentNavigationController?.pushViewController(viewController, animated: animated)
    }

    public class func pop(animated : Bool) {
        self.sharedInstance.currentNavigationController?.popViewControllerAnimated(animated)
    }
    
    public class func setCurrentNavigationController(nv : UINavigationController){
        self.sharedInstance.currentNavigationController = nv
    }
    */
    public class func dismiss(flag : Bool, navigationController : UINavigationController = UINavigationController()){
        self.sharedInstance.currentNavigationController!.dismissViewControllerAnimated(flag) { () -> Void in
            // Override sharedInstance
            self.sharedInstance = MPFlowController()
           // self.setCurrentNavigationController(navigationController)
        }
    }
    
    public class func isRoot(viewController : UIViewController) -> Bool {
        if self.sharedInstance.currentNavigationController !=  nil && self.sharedInstance.currentNavigationController!.viewControllers.count > 0 && self.sharedInstance.currentNavigationController!.viewControllers[0] == viewController {
            return true
        }
        return false
    }

   /* public class func popToRoot(animated : Bool) {
        self.sharedInstance.currentNavigationController?.popToRootViewControllerAnimated(animated)
    }*/
}
