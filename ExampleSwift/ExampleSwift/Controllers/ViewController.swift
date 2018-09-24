//
//  ViewController.swift
//  ExampleSwift
//
//  Created by Juan sebastian Sanzone on 11/9/18.
//  Copyright © 2018 Juan Sebastian Sanzone. All rights reserved.
// Check full documentation: http://mercadopago.github.io/px-ios/v4/
//

import UIKit
import MercadoPagoSDKV4

// Check full documentation: http://mercadopago.github.io/px-ios/v4/
class ViewController: UIViewController {

    private var checkout: MercadoPagoCheckout?
    private var addCardFrow: AddCardFlow?

    override func viewDidLoad() {
        super.viewDidLoad()
        //runMercadoPagoCheckout()
        runAddCard()
        //runMercadoPagoCheckoutWithLifecycle()
    }

    private func runMercadoPagoCheckout() {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder.init(publicKey: "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd", preferenceId: "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44").setLanguage("es")

        // 2) Create Checkout reference
        checkout = MercadoPagoCheckout.init(builder: builder)

        // 3) Start with your navigation controller.
        if let myNavigationController = navigationController {
            checkout?.start(navigationController: myNavigationController)
        }
    }
    
    private func runAddCard() {
        guard let navController = self.navigationController else {
            return
        }
        addCardFrow = AddCardFlow(accessToken: "APP_USR-1945000207238192-091813-19ca22bc25891fd7fa33360eb744121b-307951795", locale: "es", navigationController: navController)
        addCardFrow?.start()
    }
    
    private func runMercadoPagoCheckoutWithLifecycle() {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder.init(publicKey: "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd", preferenceId: "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44").setLanguage("es")

        // 2) Create Checkout reference
        checkout = MercadoPagoCheckout.init(builder: builder)

        // 3) Start with your navigation controller.
        if let myNavigationController = navigationController {
            checkout?.start(navigationController: myNavigationController, lifeCycleProtocol: self)
        }
    }
}

// MARK: Optional Lifecycle protocol implementation example.
extension ViewController: PXLifeCycleProtocol {
    func finishCheckout() -> ((PXResult?) -> Void)? {
        print("px - finishCheckout outsite")
        return { (pxResult) in
            print("px - finishCheckout inside")
        }
    }
    
    func cancelCheckout() -> (() -> Void)? {
        print("px - cancelCheckout outsite")
        return { () in
            print("px - cancelCheckout inside")
        }
    }

    func changePaymentMethodTapped() -> (() -> Void)? {
        print("px - changePaymentMethodTapped outsite")
        return { () in
            print("px - changePaymentMethodTapped inside")
        }
    }
}
