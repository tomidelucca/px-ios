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
    
    var navBarHeight: CGFloat = 0
    var navBarTextColor = UIColor.systemFontColor()
    var navBarBackgroundColor : UIColor?
    
    func didScrollInTable(_ scrollView: UIScrollView, tableView: UITableView){
        
        var offset = scrollView.contentOffset;
        
        if (scrollView.contentOffset.y >= -30 && isWholeTableVisible(tableView: tableView))
        {
            offset.y = -30;
            self.title = getNavigationBarTitle()
        }
        
        let visibleIndexPaths = tableView.indexPathsForVisibleRows!
        for index in visibleIndexPaths {
            if (index.section == 0){
                if !once {
                    hideNavBar()
                    
                    if (0 < tableView.contentOffset.y + (UIApplication.shared.statusBarFrame.size.height)){
                        
                        once = true
                        showNavBar()
                    }
                } else {
                    if scrollingDown {
                        once = false
                    }
                }
            } else if index.section == 1  {
                if let card = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PayerCostCardTableViewCell{
                    if tableView.contentOffset.y > 0{
                        if 44/tableView.contentOffset.y < 0.265 && !scrollingDown{
                            card.fadeCard()
                        } else{
                            card.cardView.alpha = 44/tableView.contentOffset.y;
                        }
                    }
                }
            }
        }
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            scrollingDown = true
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            scrollingDown = false
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func showNavBar() {
        self.title = self.getNavigationBarTitle()
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.isTranslucent = false
        
        if navBarBackgroundColor != nil {
            self.navigationController?.navigationBar.barTintColor = self.navBarBackgroundColor
        }

        
        let font : UIFont = UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 22) ?? UIFont.systemFont(ofSize: 22)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: self.navBarTextColor, NSFontAttributeName: font]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }
    
    func hideNavBar(){
        self.title = ""
        navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func isWholeTableVisible(tableView : UITableView) -> Bool{
        if tableView.numberOfRows(inSection: 2)>0 {
            let cellRow = tableView.cellForRow(at: IndexPath(row: tableView.numberOfRows(inSection: 2)-1, section: 2))
            
            let cellTitle = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
            if cellRow != nil && cellTitle != nil {
                let overlapRow = (cellRow?.frame)!.intersection(tableView.bounds);
                let overlapTitle = (cellTitle?.frame)!.intersection(tableView.bounds);
                if overlapRow.height == cellRow?.frame.height && overlapTitle.height == cellTitle?.frame.height {
                    return true
                }
            }
        }
        return false
    }
    
    func getNavigationBarTitle() -> String {
        return ""
    }

  
}
