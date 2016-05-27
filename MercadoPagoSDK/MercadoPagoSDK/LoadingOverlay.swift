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
    
    public func getLoadingOverlay(view : UIView, backgroundColor : UIColor, indicatorColor : UIColor) -> UIView {
        
        self.activityIndicator.frame = CGRectMake(20,20, 20, 20)
        self.activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.activityIndicator.color = indicatorColor
        self.activityIndicator.hidden = false
        

        self.container.frame = CGRectMake(0, 0, 60, 60)
        self.container.backgroundColor = backgroundColor
        self.container.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 )
        self.container.layer.cornerRadius = 10.0
        self.container.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        return self.container
    }
    
    public func showOverlay(view: UIView, backgroundColor : UIColor = UIColor().blueMercadoPago(), indicatorColor : UIColor = UIColor().backgroundColor()) {
        let overlay = self.getLoadingOverlay(view, backgroundColor : backgroundColor, indicatorColor: indicatorColor)
        view.addSubview(overlay)
        view.bringSubviewToFront(overlay)
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
