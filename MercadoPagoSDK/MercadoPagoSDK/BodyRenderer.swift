//
//  BodyRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class BodyRenderer: NSObject {

    func render(body : BodyComponent) -> UIView{
        let bodyView = UIView()
        bodyView.backgroundColor = .purple
        let textLabel = UILabel()
        textLabel.backgroundColor = .white
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyView.addSubview(textLabel)
        MPLayout.equalizeWidth(view: textLabel, to: bodyView).isActive = true
        MPLayout.equalizeHeight(view: textLabel, to: bodyView).isActive = true
        MPLayout.centerHorizontally(view: textLabel, to: bodyView).isActive = true
        MPLayout.centerVertically(view: textLabel, into: bodyView).isActive = true
        textLabel.text = body.text
        textLabel.textAlignment = .center
        return bodyView
    }
}
