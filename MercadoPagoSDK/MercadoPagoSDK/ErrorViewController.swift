//
//  ErrorViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 17/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class ErrorViewController: MercadoPagoUIViewController {

    @IBOutlet weak var errorTitle: MPLabel! 
    
    @IBOutlet internal weak var errorSubtitle: MPLabel!
    
    @IBOutlet internal weak var errorIcon: UIImageView!
    
    @IBOutlet weak var exitButton: MPButton!
    
    @IBOutlet weak var retryButton: MPButton!
    var error : MPError!
    var callback : (Void -> Void)?
    
    override public var screenName : String { get { return "ERROR" } }
    
    public init(error : MPError!, callback : (Void -> Void)?, callbackCancel : (Void -> Void)? = nil){
        super.init(nibName: "ErrorViewController", bundle: MercadoPago.getBundle())
        self.error = error
        self.callbackCancel = {
            self.dismissViewControllerAnimated(true, completion: {
                if callbackCancel != nil {
                    callbackCancel!()
                }
            })
        }
        self.callback = callback
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.errorTitle.text = error.message
        
        self.exitButton.addTarget(self, action: "invokeCallbackCancel", forControlEvents: .TouchUpInside)
        
        if self.error.retry! {
            self.retryButton.addTarget(self, action: "invokeCallback", forControlEvents: .TouchUpInside)
            self.retryButton.hidden = false
        } else {
            self.retryButton.hidden = true
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func invokeCallback(){
        if callback != nil {
            callback!()
        } else {
            if self.navigationController != nil {
                self.navigationController!.dismissViewControllerAnimated(true, completion: {})
            } else {
                self.dismissViewControllerAnimated(true, completion: {})
            }
        }
    }
    
}
