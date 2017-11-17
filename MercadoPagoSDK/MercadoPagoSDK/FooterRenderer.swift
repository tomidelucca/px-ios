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
    let M_MARGIN: CGFloat = 19.0

    let BUTTON_HEIGH: CGFloat = 50.0

    func render(footer: FooterComponent) -> FooterView {
        let fooView = FooterView()
        var topView: UIView = fooView
        fooView.translatesAutoresizingMaskIntoConstraints = false
        fooView.backgroundColor = .white
        if let principalAction = footer.data.buttonAction {
            let principalButton = self.buildPrincipalButton(with: principalAction, color: footer.data.primaryColor)
            fooView.principalButton = principalButton
            fooView.addSubview(principalButton)
            MPLayout.pinTop(view: principalButton, to: topView, withMargin: S_MARGIN).isActive = true
            MPLayout.pinLeft(view: principalButton, to: fooView, withMargin: M_MARGIN).isActive = true
            MPLayout.pinRight(view: principalButton, to: fooView, withMargin: M_MARGIN).isActive = true
            MPLayout.setHeight(owner: principalButton, height: BUTTON_HEIGH).isActive = true
            topView = principalButton
        }
        if let linkAction = footer.data.linkAction {
            let linkButton = self.buildLinkButton(with: linkAction, color: footer.data.primaryColor)
            fooView.linkButton = linkButton
            fooView.addSubview(linkButton)
            if topView != fooView {
               MPLayout.put(view: linkButton, onBottomOf: topView, withMargin: S_MARGIN).isActive = true
            }else{
                MPLayout.pinTop(view: linkButton, to: fooView, withMargin: S_MARGIN).isActive = true
            }
            
            MPLayout.pinLeft(view: linkButton, to: fooView, withMargin: M_MARGIN).isActive = true
            MPLayout.pinRight(view: linkButton, to: fooView, withMargin: M_MARGIN).isActive = true
            MPLayout.setHeight(owner: linkButton, height: BUTTON_HEIGH).isActive = true
            topView = linkButton
        }
        if topView != fooView { // Si hay al menos alguna vista dentro del footer, agrego un margen
            MPLayout.pinBottom(view: topView, to: fooView, withMargin: S_MARGIN).isActive = true
        }
        return fooView
    }
    func buildPrincipalButton(with footerAction: FooterAction, color : UIColor? = .pxBlueMp) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.setTitle(footerAction.label, for: .normal)
        button.backgroundColor = color
        button.add(for: .touchUpInside, footerAction.action)
        return button
    }
    func buildLinkButton(with footerAction: FooterAction, color : UIColor? = .pxBlueMp) -> UIButton {
        let linkButton = UIButton()
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.setTitle(footerAction.label, for: .normal)
        linkButton.setTitleColor(color, for: .normal)
        linkButton.backgroundColor = UIColor(white: 1, alpha: 0)
        linkButton.add(for: .touchUpInside, footerAction.action)
        return linkButton
    }
}

class FooterView: UIView {
    public var principalButton: UIButton?
    public var linkButton: UIButton?
}
