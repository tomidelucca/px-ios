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
        lastDefaultFontLabel = UILabel.appearance().substituteFontName
        lastDefaultFontTextField = UITextField.appearance().substituteFontName
        lastDefaultFontButton  = UIButton.appearance().substituteFontName
        UILabel.appearance().substituteFontName = "ProximaNova-Light"
        UITextField.appearance().substituteFontName = "ProximaNova-Light"
        UIButton.appearance().substituteFontName = "ProximaNova-Light"
        self.loadMPStyles()
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       UILabel.appearance().substituteFontName = lastDefaultFontLabel!
        UITextField.appearance().substituteFontName = lastDefaultFontTextField!
        UIButton.appearance().substituteFontName = lastDefaultFontButton!
    }
    internal func loadMPStyles(){
        //Navigation bar colors
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor().blueMercadoPago()
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
        shoppingCartButton.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
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
        var shoppingCartImage = MercadoPago.getImage("regular_payment")
        shoppingCartImage = shoppingCartImage!.imageWithRenderingMode(.AlwaysTemplate)
        let shoppingCartButton = UIBarButtonItem()
        shoppingCartButton.image = shoppingCartImage
        shoppingCartButton.style = UIBarButtonItemStyle.Bordered
        shoppingCartButton.imageInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        shoppingCartButton.title = ""
        shoppingCartButton.target = self
        shoppingCartButton.tintColor = UIColor.whiteColor()
        if action != nil {
            shoppingCartButton.action = action!
        }
        self.navigationItem.rightBarButtonItem = shoppingCartButton
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


extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
}
extension UITextField {
    
    var substituteFontName : String {
        get { return self.font!.fontName }
        set { self.font = UIFont(name: newValue, size: self.font!.pointSize) }
    }
    
}



extension UIButton {
    
    var substituteFontName : String {
        get { return self.titleLabel!.font.fontName }
        set {if (self.titleLabel != nil){
            self.titleLabel!.font = UIFont(name: newValue, size: self.titleLabel!.font.pointSize) 
            }
            }
    }
    
}

