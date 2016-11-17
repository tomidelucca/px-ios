//
//  MercadoPagoUIScrollViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 11/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class MercadoPagoUIScrollViewController: MercadoPagoUIViewController {

    var once = false
    var lastContentOffset: CGFloat = 0
    var scrollingDown = false
    
    var navBarBackgroundColor : UIColor?
    
    func didScrollInTable(_ scrollView: UIScrollView) { //, tableView: UIScrollView){
        
        
         //   let visibleIndexPaths = scrollView.indexPathsForVisibleRows!
        
      //      for index in visibleIndexPaths {
        print(scrollView.contentOffset.y)
        if (scrollView.contentOffset.y > -30) {
                    if !once {
                        hideNavBar()
                        if (0 < scrollView.contentOffset.y + (UIApplication.shared.statusBarFrame.size.height)){
                            once = true
                            showNavBar()
                        }
                    } else {
                        if scrollingDown {
                            once = false
                        }
                    }
                }
        //    }
            if (self.lastContentOffset > scrollView.contentOffset.y) {
                scrollingDown = true
            }
            else if (self.lastContentOffset < scrollView.contentOffset.y) {
                scrollingDown = false
            }
            self.lastContentOffset = scrollView.contentOffset.y
       
    }
    


  
}
