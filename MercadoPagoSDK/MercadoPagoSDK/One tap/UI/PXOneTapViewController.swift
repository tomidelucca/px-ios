//
//  PXOneTapViewController.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoPXTracking

final class PXOneTapViewController: PXComponentContainerViewController {

    // MARK: Tracking
    override var screenName: String { return TrackingUtil.SCREEN_NAME_REVIEW_AND_CONFIRM_ONE_TAP }
    override var screenId: String { return TrackingUtil.SCREEN_ID_REVIEW_AND_CONFIRM_ONE_TAP }

    // MARK: Definitions
    lazy var itemViews = [UIView]()
    fileprivate var viewModel: PXOneTapViewModel
    private var footerView: UIView!

    var callbackPaymentData: ((PaymentData) -> Void)
    var callbackConfirm: ((PaymentData) -> Void)
    var callbackExit: (() -> Void)

    // MARK: Lifecycle - Publics
    init(viewModel: PXOneTapViewModel, callbackPaymentData : @escaping ((PaymentData) -> Void), callbackConfirm: @escaping ((PaymentData) -> Void), callbackExit: @escaping (() -> Void)) {
        self.viewModel = viewModel
        self.callbackPaymentData = callbackPaymentData
        self.callbackConfirm = callbackConfirm
        self.callbackExit = callbackExit
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        self.view.layoutIfNeeded()
    }

    override func trackInfo() {
        self.viewModel.trackInfo()
    }

    func update(viewModel: PXOneTapViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: UI Methods
extension PXOneTapViewController {

    fileprivate func setupUI() {
        navBarTextColor = ThemeManager.shared.labelTintColor()
        loadMPStyles()
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.whiteColor()
        navigationItem.leftBarButtonItem?.tintColor = ThemeManager.shared.labelTintColor()
        if contentView.getSubviews().isEmpty {
            renderViews()
        }
    }

    fileprivate func renderViews() {

        self.contentView.prepareForRender()

        // Add item views
        itemViews = buildItemComponentsViews()
        for itemView in itemViews {
            contentView.addSubviewToBottom(itemView)
            PXLayout.centerHorizontally(view: itemView).isActive = true
            PXLayout.matchWidth(ofView: itemView).isActive = true
            itemView.addSeparatorLineToBottom(height: 1)
        }

        // Add payment method view.
        if let paymentMethodView = getPaymentMethodComponentView() {
            contentView.addSubviewToBottom(paymentMethodView)
            PXLayout.pinLeft(view: paymentMethodView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: paymentMethodView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.setHeight(owner: paymentMethodView, height: 80).isActive = true
        }

        //Add Footer payment button
        footerView = getFooterView()
        contentView.addSubviewToBottom(footerView)
        PXLayout.matchWidth(ofView: footerView).isActive = true
        PXLayout.pinBottom(view: footerView).isActive = true
        PXLayout.centerHorizontally(view: footerView).isActive = true

        self.view.layoutIfNeeded()
        PXLayout.setHeight(owner: footerView, height: footerView.frame.height).isActive = true

        // Add elastic header.
        addElasticHeader(headerBackgroundColor: ThemeManager.shared.whiteColor(), navigationCustomTitle: "", textColor: ThemeManager.shared.labelTintColor())

        self.view.layoutIfNeeded()
        super.refreshContentViewSize()
    }
}

// MARK: Component Builders
extension PXOneTapViewController {

    fileprivate func buildItemComponentsViews() -> [UIView] {
        var itemViews = [UIView]()
        let itemComponents = viewModel.buildItemComponents()
        for items in itemComponents {
            itemViews.append(items.render())
        }
        return itemViews
    }

    fileprivate func getPaymentMethodComponentView() -> UIView? {
        let action = PXComponentAction(label: "review_change_payment_method_action".localized_beta, action: { [weak self] in
            if let reviewViewModel = self?.viewModel {
                self?.viewModel.trackChangePaymentMethodEvent()
                self?.callbackPaymentData(reviewViewModel.getClearPaymentData())
            }
        })
        if let paymentMethodComponent = viewModel.getPaymentMethodComponent(withAction: action) {
            return paymentMethodComponent.oneTapRender()
        }
        return nil
    }

    fileprivate func getFooterView() -> UIView {
        let payAction = PXComponentAction(label: "Confirmar".localized) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.confirmPayment()
        }
        let footerProps = PXFooterProps(buttonAction: payAction)
        let footerComponent = PXFooterComponent(props: footerProps)
        return footerComponent.oneTapRender()
    }
}

// MARK: Actions.
extension PXOneTapViewController {
    fileprivate func confirmPayment() {
        self.viewModel.trackConfirmActionEvent()
        self.hideNavBar()
        self.hideBackButton()
        self.callbackConfirm(self.viewModel.paymentData)
    }

    fileprivate func cancelPayment() {
        self.callbackExit()
    }
}
