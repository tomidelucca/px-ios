//
//  FooterRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class FooterRenderer: NSObject {

    let S_MARGIN: CGFloat = 16.0
    
    let BUTTON_HEIGH: CGFloat = 50.0
    
    func render(footer: FooterComponent) -> FooterView {
        let fooView = FooterView()
        var topView : UIView = fooView
        fooView.translatesAutoresizingMaskIntoConstraints = false
        fooView.backgroundColor = .white
        if let principalAction = footer.data.buttonAction {
            let principalButton = self.buildPrincipalButton(with: principalAction)
            fooView.principalButton = principalButton
            fooView.addSubview(principalButton)
            MPLayout.pinTop(view: principalButton, to: topView, withMargin: S_MARGIN).isActive = true
            MPLayout.pinLeft(view: principalButton, to: fooView, withMargin: S_MARGIN).isActive = true
            MPLayout.pinRight(view: principalButton, to: fooView, withMargin: S_MARGIN).isActive = true
            MPLayout.setHeight(owner: principalButton, height: BUTTON_HEIGH).isActive = true
            topView = principalButton
        }
        if let linkAction = footer.data.linkAction {
            let linkButton = self.buildLinkButton(with: linkAction)
            fooView.linkButton = linkButton
            fooView.addSubview(linkButton)
            MPLayout.put(view: linkButton, onBottomOf: topView, withMargin: S_MARGIN).isActive = true
            MPLayout.pinLeft(view: linkButton, to: fooView, withMargin: S_MARGIN).isActive = true
            MPLayout.pinRight(view: linkButton, to: fooView, withMargin: S_MARGIN).isActive = true
            MPLayout.setHeight(owner: linkButton, height: BUTTON_HEIGH).isActive = true
            topView = linkButton
        }
        if topView != fooView { // Si hay al menos alguna vista dentro del footer, agrego un margen
            MPLayout.pinBottom(view: topView, to: fooView, withMargin: S_MARGIN).isActive = true
        }
        return fooView
    }
    func buildPrincipalButton(with footerAction: FooterAction) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(footerAction.label, for: .normal)
        button.backgroundColor = .pxGreenMp
        button.actionHandle(controlEvents: UIControlEvents.touchUpInside, ForAction: footerAction.action)
        return button
    }
    func buildLinkButton(with footerAction: FooterAction) -> UIButton {
        let linkButton = UIButton()
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.setTitle(footerAction.label, for: .normal)
        linkButton.setTitleColor(.blue, for: .normal)
        linkButton.backgroundColor = UIColor(white: 1, alpha: 0)
        
        linkButton.actionHandle(controlEvents: UIControlEvents.touchUpInside, ForAction: footerAction.action)
        return linkButton
    }
}


class FooterView : UIView {
    public var principalButton: UIButton?
    public var linkButton: UIButton?
}




//        fooView.translatesAutoresizingMaskIntoConstraints = false
//        fooView.isUserInteractionEnabled = true
//        fooView.backgroundColor = .yellow
//        let title = UILabel()
//        title.backgroundColor = .red
//        let button = UIButton()
//        button.backgroundColor = .green
//        fooView.addSubview(title)
//        fooView.addSubview(button)
//        title.translatesAutoresizingMaskIntoConstraints = false
//        button.translatesAutoresizingMaskIntoConstraints = false
//        MPLayout.pinTop(view: title, to: fooView, withMargin: 10).isActive = true
//        MPLayout.pinLeft(view: title, to: fooView, withMargin: 10).isActive = true
//        MPLayout.pinRight(view: title, to: fooView, withMargin: 10).isActive = true
//        MPLayout.setHeight(owner: title, height: 20).isActive = true
//        title.text = footer.titleLabel
//        title.textAlignment = .center
//        MPLayout.pinBottom(view: button, to: fooView, withMargin: 10).isActive = true
//        MPLayout.pinLeft(view: button, to: fooView, withMargin: 10).isActive = true
//        MPLayout.pinRight(view: button, to: fooView, withMargin: 10).isActive = true
//        MPLayout.setHeight(owner: button, height: 30).isActive = true
//        button.setTitle(footer.titleButton, for: .normal)
//        button.actionHandle(controlEvents: UIControlEvents.touchUpInside, ForAction: {() -> Void in
//            if let action = footer.actionButton {
//                action()
//            }
//        })
//        MPLayout.setHeight(owner: fooView, height: 80).isActive = true


