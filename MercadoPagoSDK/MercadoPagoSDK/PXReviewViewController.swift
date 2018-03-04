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

    // MARK: Lifecycle - Publics
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
    
    func update(viewModel: PXReviewViewModel) {
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
            
            // Add title view.
            let titleView = getTitleComponentView()
            contentView.addSubview(titleView)
            PXLayout.pinTop(view: titleView, to: contentView, withMargin: 0).isActive = true
            PXLayout.centerHorizontally(view: titleView).isActive = true
            PXLayout.matchWidth(ofView: titleView).isActive = true
            
            // Add summary view.
            let summaryView = getSummaryComponentView()
            contentView.addSubview(summaryView)
            PXLayout.put(view: summaryView, onBottomOf: titleView, withMargin: 0).isActive = true
            PXLayout.centerHorizontally(view: summaryView).isActive = true
            PXLayout.matchWidth(ofView: summaryView).isActive = true
            
            // Add payment method view.
            let paymentMethodView = getPaymentMethodComponentView()
            contentView.addSubview(paymentMethodView)
            PXLayout.matchWidth(ofView: paymentMethodView).isActive = true
            PXLayout.put(view: paymentMethodView, onBottomOf: summaryView, withMargin: 0).isActive = true
            PXLayout.centerHorizontally(view: paymentMethodView).isActive = true
            
            // TODO: Set proper content size.
            scrollView.contentSize = CGSize(width: PXLayout.getScreenWidth(), height: 1600)
            
            // Add elastic header.
            addElasticHeader(headerBackgroundColor: summaryView.backgroundColor, navigationCustomTitle: PXReviewTitleComponentProps.DEFAULT_TITLE.localized)
        }
    }
    
    fileprivate func getPaymentMethodComponentView() -> UIView {
        let action = PXComponentAction(label: "Action label") {
            print("Action called")
        }
        let paymentMethodComponent = viewModel.buildPaymentMethodComponent(withAction:action)
        let paymentMethodView = paymentMethodComponent.render()
        return paymentMethodView
    }
    
    fileprivate func getSummaryComponentView() -> UIView {
        let summaryComponent = viewModel.buildSummaryComponent(width: PXLayout.getScreenWidth())
        let summaryView = summaryComponent.render()
        return summaryView
    }
    
    fileprivate func getTitleComponentView() -> UIView {
        let titleComponent = viewModel.buildTitleComponent()
        return titleComponent.render()
    }
}
