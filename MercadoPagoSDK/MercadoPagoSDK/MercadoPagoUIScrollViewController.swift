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
    let navBarHeigth: CGFloat = 44
    let statusBarHeigth: CGFloat = 20
    var titleCellHeight: CGFloat = 70

    func scrollPositionToShowNavBar () -> CGFloat {
        return titleCellHeight - statusBarHeigth
    }
    
    func didScrollInTable(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if (scrollView.contentOffset.y > -scrollPositionToShowNavBar() ) {
            showNavBar()
        } else {
            hideNavBar()
        }
    }
    
    
    override func getNavigationBarTitle() -> String {
        return ""
    }
    


  
}
