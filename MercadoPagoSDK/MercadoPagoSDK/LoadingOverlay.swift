//
//  LoadingOverlay.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 29/4/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class LoadingOverlay {
    
    var container = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }

    init(){
        
    }
    
    public func getLoadingOverlay(view : UIView) -> UIView {
        
        let x = (view.frame.size.width - 20) / 2
        let y = (view.frame.size.height - 20) / 2
        self.activityIndicator.frame = CGRectMake(x,y, 20, 20)
        self.activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.activityIndicator.color = UIColor().blueMercadoPago()
        
        
        self.container.frame = view.frame
        self.container.backgroundColor = UIColor().backgroundColor()
        self.container.center = view.center
     //   self.activityIndicator.center = view.center
        self.container.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        return self.activityIndicator
    }
    
    public func showOverlay(view: UIView) {
        let overlay = self.getLoadingOverlay(view)
        view.addSubview(overlay)
        view.bringSubviewToFront(overlay)
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
