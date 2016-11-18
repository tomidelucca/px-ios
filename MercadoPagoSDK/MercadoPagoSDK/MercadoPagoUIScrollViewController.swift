//
//  MercadoPagoUIScrollViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 11/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class MercadoPagoUIScrollViewController: MercadoPagoUIViewController {

    var displayNavBar = false
    var lastContentOffset: CGFloat = 0
    var scrollingDown = false
    var navBarHeight : CGFloat = -18
    
    
    
    func didScrollInTable(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.y)
        print("navBar : " + String(describing: navBarHeight))
        if (scrollView.contentOffset.y > navBarHeight + UIApplication.shared.statusBarFrame.size.height) {
            /*if !self.displayNavBar {
                
                if (0 < scrollView.contentOffset.y + (UIApplication.shared.statusBarFrame.size.height)){
                    self.displayNavBar = true
                    showNavBar()
                } else {
                    hideNavBar()
                }
            } else {
                if self.scrollingDown {
                    self.displayNavBar = false
                }
            }*/
            showNavBar()
            
        } else {
            hideNavBar()
        }
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            self.scrollingDown = true
        } else {
            self.scrollingDown = false
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
        print("scrolling : " + String(scrollingDown))
        
    }
    
    
    override func getNavigationBarTitle() -> String {
        return ""
    }
    


  
}
