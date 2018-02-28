//
//  PXReviewViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/2/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoPXTracking

class PXReviewViewController: PXComponentContainerViewController {
    
    //MARK: Tracking
    override open var screenName: String { get { return TrackingUtil.SCREEN_NAME_REVIEW_AND_CONFIRM } }
    override open var screenId: String { get { return TrackingUtil.SCREEN_ID_REVIEW_AND_CONFIRM } }
    
    //MARK: Definitions
    fileprivate var viewModel: PXReviewViewModel!
    
    //MARK: Lifecycle - Publics
    init(viewModel: PXReviewViewModel) {
        super.init()
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        setupUI()
    }
    
    func update(viewModel:PXReviewViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: UI Methods
extension PXReviewViewController {
    
    fileprivate func setupUI() {
        renderViews()
        scrollView.backgroundColor = .white
        setNavBarBackgroundColor(color: .white)
        navBarTextColor = .primaryColor() // TODO: Replace with Theme.
    }
    
    fileprivate func renderViews() {
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        for constraint in contentView.constraints {
            constraint.isActive = false
        }
        
        // Add Payment Method
        let paymentMethodView = self.buildPaymentMethodView()
        contentView.addSubview(paymentMethodView)
        PXLayout.pinTop(view: paymentMethodView, to: contentView).isActive = true
        PXLayout.centerHorizontally(view: paymentMethodView).isActive = true
        PXLayout.matchWidth(ofView: paymentMethodView).isActive = true
    }
}
// MARK: Create Components
extension PXReviewViewController {
    fileprivate func getPaymentMethodIcon(paymentMethod: PaymentMethod) -> UIImage? {
        let defaultColor = paymentMethod.paymentTypeId == PaymentTypeId.ACCOUNT_MONEY.rawValue && paymentMethod.paymentTypeId != PaymentTypeId.PAYMENT_METHOD_PLUGIN.rawValue
        var paymentMethodImage: UIImage? =  MercadoPago.getImageForPaymentMethod(withDescription: paymentMethod._id, defaultColor: defaultColor)
        // Retrieve image for payment plugin or any external payment method.
        if paymentMethod.paymentTypeId == PaymentTypeId.PAYMENT_METHOD_PLUGIN.rawValue {
            paymentMethodImage = paymentMethod.getImageForExtenalPaymentMethod()
        }
        return paymentMethodImage
    }
    
    func buildPaymentMethodView() -> UIView {
        let pm = self.viewModel.paymentData!.paymentMethod!
        
        let image = getPaymentMethodIcon(paymentMethod: pm)
        var amountTitle = ""
        let paymentMethodName = pm.name ?? ""
        
        if pm.isCard {
            if let lastFourDigits = (self.viewModel.paymentData.token?.lastFourDigits) {
                amountTitle = paymentMethodName + " " + "terminada en ".localized + lastFourDigits
            }
        } else {
            amountTitle = paymentMethodName
        }
        
        let action = PXComponentAction(label: "Hola pulpo") {
            print("boton tocado")
        }
        let amountDetail = "HSBC"
        let bodyProps = PXPaymentMethodProps(paymentMethodIcon: image, amountTitle: amountTitle, amountDetail: amountDetail, paymentMethodDescription: nil, paymentMethodDetail: nil, disclaimer: nil, action: action)
        
        return PXPaymentMethodComponent(props: bodyProps).render()
    }
}
