//
//  TestComponent.swift
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Demian Tejo on 19/12/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoSDKV4

@objc public class TestComponent: NSObject {
    public func getView() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 500, height: 100)
        let view = UIView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Custom Component"
        label.font = label.font.withSize(20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        view.addSubview(label)

        NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0).isActive = true

        NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0).isActive = true

        return view
    }
}

// MARK: Mock configurations (Ex-preferences).
extension TestComponent {
    static public func getPaymentResultConfiguration() -> PXPaymentResultConfiguration {
        let top = TestComponent()
        let bottom = TestComponent()
        let paymentConfig = PXPaymentResultConfiguration(topView: top.getView(), bottomView: bottom.getView())
        return paymentConfig
    }

    static public func getReviewConfirmConfiguration() -> PXReviewConfirmConfiguration {
        let top = TestComponent()
        let bottom = TestComponent()
        let config = PXReviewConfirmConfiguration(itemsEnabled: true, topView: top.getView(), bottomView: bottom.getView())
        let vc = ReviewViewControllerHookTest()
        config.setReviewVC(viewController: vc)
        return config
    }
}

class ReviewViewControllerHookTest: UIViewController, PXPreReviewScreen {

    var navigationHandler: PXHookNavigationHandler!

    func configViewController() -> UIViewController {
        self.view = UIView()
        self.view.backgroundColor = .white

        let frame = CGRect(x: 100, y: 100, width: 200, height: 66)
        let button = UIButton(frame: frame)
        button.backgroundColor = .blue
        button.setTitle("Next", for: .normal)
        button.addTarget(navigationHandler, action: #selector(navigationHandler.next), for: .touchUpInside)

        view.addSubview(button)

        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0).isActive = true

        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0).isActive = true
        return self
    }

    func shouldSkipHook(hookStore: PXCheckoutStore) -> Bool {
        return false
    }

    func navigationHandlerForHook(navigationHandler: PXHookNavigationHandler) {
        self.navigationHandler = navigationHandler
    }
}
