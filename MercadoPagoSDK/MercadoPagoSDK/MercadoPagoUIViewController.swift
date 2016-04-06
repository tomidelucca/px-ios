//
//  MercadoPagoUIViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 3/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class MercadoPagoUIViewController: UIViewController {

    internal var displayPreferenceDescription = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadMPStyles()
        
        //Create custom button with shopping cart
        rightButtonShoppingCart()
    }
    
    var lastDefaultFontLabel : String?
    var lastDefaultFontTextField : String?
    var lastDefaultFontButton : String?

    static func loadFont(fontName: String) -> Bool {
        
        
        if let path = MercadoPago.getBundle()!.pathForResource(fontName, ofType: "ttf")
        {
            if let inData = NSData(contentsOfFile: path)
            {
                var error: Unmanaged<CFError>?
                let cfdata = CFDataCreate(nil, UnsafePointer<UInt8>(inData.bytes), inData.length)
                if let provider = CGDataProviderCreateWithCFData(cfdata) {
                    if let font = CGFontCreateWithDataProvider(provider) {
                        if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
                            print("Failed to load font: \(error)")
                        }
                        return true
                    }
                }
            }
        }
        return false
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MercadoPagoUIViewController.loadFont("ProximaNova-Light")
        
        self.loadMPStyles()
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    internal func loadMPStyles(){
        //Navigation bar colors
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "ProximaNova-Light", size: 18)!]

        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor().blueMercadoPago()
        
        self.navigationItem.hidesBackButton = true
        
        
        let backButton = UIBarButtonItem()
        backButton.image = MercadoPago.getImage("left_arrow")
        backButton.style = UIBarButtonItemStyle.Bordered
        backButton.target = self
        backButton.tintColor = UIColor.whiteColor()
        backButton.action = "executeBack"
        backButton.imageInsets = UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 2)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    internal func clearMercadoPagoStyleAndGoBackAnimated(){
        self.clearMercadoPagoStyle()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    internal func clearMercadoPagoStyleAndGoBack(){
        self.clearMercadoPagoStyle()
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    internal func clearMercadoPagoStyle(){
        //Navigation bar colors
        self.navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.barTintColor = nil
      
    }
    
    internal func togglePreferenceDescription(table : UITableView){
        if displayPreferenceDescription {
            self.rightButtonShoppingCart()
        } else {
            self.rightButtonClose()
        }
        displayPreferenceDescription = !displayPreferenceDescription
        table.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Middle)
    }

    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func shouldAutorotate() -> Bool {
        return false
    }
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    public func rightButtonClose(){
        let action = self.navigationItem.rightBarButtonItem?.action
        var shoppingCartImage = MercadoPago.getImage("iconClose")
        shoppingCartImage = shoppingCartImage!.imageWithRenderingMode(.AlwaysTemplate)
        let shoppingCartButton = UIBarButtonItem()
        shoppingCartButton.image = shoppingCartImage
        shoppingCartButton.style = UIBarButtonItemStyle.Bordered
        shoppingCartButton.title = ""
        shoppingCartButton.target = self
        shoppingCartButton.tintColor = UIColor.whiteColor()
        if action != nil {
            shoppingCartButton.action = action!
        }
        self.navigationItem.rightBarButtonItem = shoppingCartButton
    }
    
    public func rightButtonShoppingCart(){
        let action = self.navigationItem.rightBarButtonItem?.action
        var shoppingCartImage = MercadoPago.getImage("iconCart")
        shoppingCartImage = shoppingCartImage!.imageWithRenderingMode(.AlwaysTemplate)
        let shoppingCartButton = UIBarButtonItem()
        shoppingCartButton.image = shoppingCartImage
        shoppingCartButton.title = ""
        shoppingCartButton.target = self
        shoppingCartButton.tintColor = UIColor.whiteColor()
        if action != nil {
            shoppingCartButton.action = action!
        }
        self.navigationItem.rightBarButtonItem = shoppingCartButton
    }
    
    internal func executeBack(){
        self.clearMercadoPagoStyle()
        if MPFlowController.isRoot(self) {
            MPFlowController.dismiss(true)
        } else {
            MPFlowController.pop(true)
        }
    }

}

extension UINavigationController {

    override public func shouldAutorotate() -> Bool {
        return (self.viewControllers.count > 0 && self.viewControllers.last!.shouldAutorotate())
    }
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return self.viewControllers.last!.supportedInterfaceOrientations()
    }
}

