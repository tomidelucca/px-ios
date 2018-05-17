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
    private lazy var footerView: UIView = UIView()

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
    }

    override func trackInfo() {
        self.viewModel.trackInfo()
    }

    func update(viewModel: PXOneTapViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: UI Methods.
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

        // Add payment method.
        if let paymentMethodView = getPaymentMethodComponentView() {
            contentView.addSubviewToBottom(paymentMethodView)
            PXLayout.pinLeft(view: paymentMethodView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: paymentMethodView, withMargin: PXLayout.M_MARGIN).isActive = true
            let paymentMethodTapAction = UITapGestureRecognizer(target: self, action: #selector(self.shouldChangePaymentMethod))
            paymentMethodView.addGestureRecognizer(paymentMethodTapAction)
            self.view.layoutIfNeeded()
        }

        let rowView = PXSummaryRowComponent(props: (title: "AySA", subTitle: "Factura agua", rightText: "$ 1200")).oneTapRender()
        contentView.addSubviewToBottom(rowView)
        PXLayout.pinLeft(view: rowView, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.pinRight(view: rowView, withMargin: PXLayout.M_MARGIN).isActive = true

        let rowView2 = PXSummaryRowComponent(props: (title: "Edenor", subTitle: "Pago de luz mensual", rightText: "$ 400")).oneTapRender()
        contentView.addSubviewToBottom(rowView2)
        PXLayout.pinLeft(view: rowView2, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.pinRight(view: rowView2, withMargin: PXLayout.M_MARGIN).isActive = true

        // Add footer payment button.
        footerView = getFooterView()
        contentView.addSubviewToBottom(footerView)
        PXLayout.matchWidth(ofView: footerView).isActive = true
        PXLayout.centerHorizontally(view: footerView).isActive = true

        self.view.layoutIfNeeded()
        super.refreshContentViewSize()
    }
}

// MARK: Components Builders.
extension PXOneTapViewController {
    fileprivate func getPaymentMethodComponentView() -> UIView? {
        if let paymentMethodComponent = viewModel.getPaymentMethodComponent() {
            return paymentMethodComponent.oneTapRender()
        }
        return nil
    }

    fileprivate func getFooterView() -> UIView {
        let payAction = PXComponentAction(label: "Confirmar".localized) { [weak self] in
            self?.confirmPayment()
        }
        let footerProps = PXFooterProps(buttonAction: payAction)
        let footerComponent = PXFooterComponent(props: footerProps)
        return footerComponent.oneTapRender()
    }
}

// MARK: User Actions.
extension PXOneTapViewController {
    @objc func shouldChangePaymentMethod() {
        viewModel.trackChangePaymentMethodEvent()
        callbackPaymentData(viewModel.getClearPaymentData())
    }

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
