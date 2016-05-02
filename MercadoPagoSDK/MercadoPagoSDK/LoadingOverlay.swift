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
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
    
        self.container.center = view.center
        self.container.backgroundColor = UIColor.redColor()
        self.container.alpha = 1.0
        
        self.loadingView.frame = CGRectMake(0, 0, 80, 80)
        self.loadingView.backgroundColor = UIColor().blueMercadoPago()
        self.loadingView.clipsToBounds = true
        self.loadingView.layer.cornerRadius = 10
        self.loadingView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        self.activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        self.activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.activityIndicator.center = CGPointMake(loadingView.bounds.width / 2, loadingView.bounds.height / 2)
        
        self.loadingView.addSubview(activityIndicator)
        self.container.addSubview(loadingView)
        self.activityIndicator.startAnimating()
        view.addSubview(self.container)
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
