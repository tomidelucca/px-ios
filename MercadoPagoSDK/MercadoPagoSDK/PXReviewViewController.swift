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
    
    // MARK: Tracking
    override open var screenName: String { get { return TrackingUtil.SCREEN_NAME_REVIEW_AND_CONFIRM } }
    override open var screenId: String { get { return TrackingUtil.SCREEN_ID_REVIEW_AND_CONFIRM } }
    
    // MARK: Definitions
    fileprivate var viewModel: PXReviewViewModel!

    var callbackPaymentData: ((PaymentData) -> Void)!
    
    // MARK: Lifecycle - Publics
    init(viewModel: PXReviewViewModel, callbackPaymentData : @escaping (PaymentData) -> Void) {
        super.init()
        self.viewModel = viewModel
        self.callbackPaymentData = callbackPaymentData
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
        // TODO: Implement reactive UI on viewModel didSet.
        self.viewModel = viewModel
    }
}

// MARK: UI Methods
extension PXReviewViewController {
    
    fileprivate func setupUI() {
        scrollView.backgroundColor = .white
        setNavBarBackgroundColor(color: .white)
        renderViews()
    }
    
    fileprivate func renderViews() {
        
        if contentView.subviews.isEmpty {
           
            for view in contentView.subviews {
                view.removeFromSuperview()
            }
            
            for constraint in contentView.constraints {
                constraint.isActive = false
            }
            
            addPaymentMethodComponent()
        }
    }
    
    fileprivate func addPaymentMethodComponent() {
        
        let action = PXComponentAction(label: "review_change_payment_method_action".localized_beta) {
            self.callbackPaymentData(self.viewModel.getClearPaymentData())
        }
        
        if let paymentMethodComponent = viewModel.buildPaymentMethodComponent(withAction:action) {
            let paymentMethodView = paymentMethodComponent.render()
            contentView.addSubview(paymentMethodView)
            PXLayout.pinTop(view: paymentMethodView, to: contentView).isActive = true
            PXLayout.centerHorizontally(view: paymentMethodView).isActive = true
            PXLayout.matchWidth(ofView: paymentMethodView).isActive = true
            PXLayout.pinBottom(view: paymentMethodView, to: contentView).isActive = true
        }
    }
}
