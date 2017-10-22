//
//  HeaderRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/18/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class HeaderRenderer: NSObject {

    
    func render(header : HeaderComponent ) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .orange
        
        let image = UIView()
        image.backgroundColor = .gray
         image.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(image)
         MPLayout.setHeight(owner: image, height: 40).isActive = true
         MPLayout.setWeight(owner: image, weight: 40).isActive = true
        MPLayout.centerHorizontally(view: image, to: headerView).isActive = true
         MPLayout.pinTop(view: image, to: headerView, withMargin: 50).isActive = true

        let textLabel = UILabel()
        headerView.addSubview(textLabel)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
         MPLayout.centerHorizontally(view: textLabel, to: headerView).isActive = true
        MPLayout.put(view: textLabel, onBottomOf:image, withMargin: 20).isActive = true
        MPLayout.equalizeWidth(view: textLabel, to: headerView).isActive = true
        textLabel.text = header.title
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        
 
        return headerView
    }
}
