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
        
        //Navigation bar colors
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor().blueMercadoPago()
        
        //Custom back button with shopping cart
        var shoppingCartImage = MercadoPago.getImage("regular_payment")
        shoppingCartImage = shoppingCartImage!.imageWithRenderingMode(.AlwaysTemplate)
        let shoppingCartButton = UIBarButtonItem()
        shoppingCartButton.image = shoppingCartImage
        shoppingCartButton.title = ""
        shoppingCartButton.target = self
        shoppingCartButton.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = shoppingCartButton
    }
    
    internal func clearMercadoPagoStyle(){
        //Navigation bar colors
        self.navigationController!.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.barTintColor = nil
        
        //Custom back button with shopping cart
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    internal func togglePreferenceDescription(table : UITableView){
        displayPreferenceDescription = !displayPreferenceDescription
        table.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }

    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
