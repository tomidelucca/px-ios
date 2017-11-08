//
//  FooterRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class FooterRenderer: NSObject {

    func render(footer: FooterComponent) -> UIView {
        let fooView = UIView()
        fooView.translatesAutoresizingMaskIntoConstraints = false
        fooView.isUserInteractionEnabled = true
        fooView.backgroundColor = .yellow
        let title = UILabel()
        title.backgroundColor = .red
        let button = UIButton()
        button.backgroundColor = .green
        fooView.addSubview(title)
        fooView.addSubview(button)
        title.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        MPLayout.pinTop(view: title, to: fooView, withMargin: 10).isActive = true
        MPLayout.pinLeft(view: title, to: fooView, withMargin: 10).isActive = true
        MPLayout.pinRight(view: title, to: fooView, withMargin: 10).isActive = true
        MPLayout.setHeight(owner: title, height: 20).isActive = true
        title.text = footer.titleLabel
        title.textAlignment = .center
        MPLayout.pinBottom(view: button, to: fooView, withMargin: 10).isActive = true
        MPLayout.pinLeft(view: button, to: fooView, withMargin: 10).isActive = true
        MPLayout.pinRight(view: button, to: fooView, withMargin: 10).isActive = true
        MPLayout.setHeight(owner: button, height: 30).isActive = true
        button.setTitle(footer.titleButton, for: .normal)
        button.actionHandle(controlEvents: UIControlEvents.touchUpInside, ForAction: {() -> Void in
            if let action = footer.actionButton {
                action()
            }
        })
        MPLayout.setHeight(owner: fooView, height: 80).isActive = true
        return fooView
    }
}
